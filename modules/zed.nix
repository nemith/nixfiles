{ inputs, ... }: {
  flake.modules.homeManager.zed =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      package =
        let
          version = "1.5.4";
          src = pkgs.applyPatches {
            name = "zed-${version}-patched-source";
            src = pkgs.fetchFromGitHub {
              owner = "zed-industries";
              repo = "zed";
              tag = "v${version}";
              hash = "sha256-I9+v5qeubBA9bAS4OU7V/BsxxfP5rj9aS4xvopbF578=";
            };
            patches = [
              # https://github.com/zed-industries/zed/pull/58300
              (pkgs.fetchpatch {
                name = "claude-code-ide-integration.patch";
                url = "https://github.com/zed-industries/zed/pull/58300.patch";
                hash = "sha256-rmINlWZjLaTev3WCo837Hgqg8U0/L0UfRwBfJtPwptc=";
              })
            ];
          };
        in
        pkgs.zed-editor.overrideAttrs (prev: {
          inherit version src;
          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            pname = "zed-editor";
            inherit version src;
            hash = "sha256-tpy7Axfsg/dvsgReDJEEBOdnxMeaC/3D4+CaHUvlTUk=";
            postBuild = ''
              rm -r $out/git/*/candle-book/
            '';
          };
          # zed 1.5.x's final binary is large enough that inter-section branches
          # exceed the ARM64 ±128 MB range. nixpkgs' cctools ld64 errors out;
          # lld inserts branch islands automatically.
          nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ pkgs.llvmPackages.bintools ];
          env = (prev.env or { }) // {
            NIX_CFLAGS_LINK = "-fuse-ld=lld";
          };
        });
    in
    {
      home.packages =
        with pkgs;
        [ maple-mono.NF ]
        ++ lib.optionals stdenv.isDarwin [
          (writeShellScriptBin "zed" ''
            exec zeditor --zed "$HOME/Applications/Home Manager Apps/Zed.app" "$@"
          '')
        ];

      home.shellAliases = lib.mkIf pkgs.stdenv.isDarwin { zeditor = "zed"; };

      programs.zed-editor = {
        enable = true;
        inherit package;

        enableMcpIntegration = true;
        installRemoteServer = true;

        extensions = [
          "ansible"
          "basher"
          "cmake"
          "direnv"
          "docker-compose"
          "dockerfile"
          "github-actions"
          "gleam"
          "golangci-lint"
          "helm"
          "jj-lsp"
          "just"
          "kdl"
          "kubernetes"
          "log"
          "lua"
          "make"
          "marksman"
          "mermaid"
          "nix"
          "pkl"
          "proto"
          "ruff"
          "sql"
          "systemd-files"
          "terraform"
          "toml"
          "yaml"
          "zig"
        ];

        extraPackages = with pkgs; [
          # rust
          rust-analyzer

          # go
          gopls
          gotools

          # python
          uv
          ruff
          pyright # or basedpyright if you prefer

          # Nix
          nixd # or nil

          # Gleam
          gleam

          # Protobuf / Buf
          buf
          protobuf

          # Shell
          shellcheck
          bash-language-server
          shfmt

          # YAML
          yaml-language-server
          prettier

          # Ansible
          ansible-language-server

          # Terraform
          terraform-ls

          # Helm
          helm-ls

          # Markdown
          marksman

          # General
          nodejs # needed for some LSPs / ACP adapters
        ];

        userSettings = {
          hour_format = "hour24";
          base_keymap = "VSCode";
          vim_mode = true;
          format_on_save = "on";
          formatter = "language_server";

          bottom_dock_layout = "right_aligned";
          buffer_font_family = "Maple Mono NF";
          buffer_font_size = 12;
          terminal = {
            font_family = "Maple Mono NF";
          };
          colorize_brackets = true;
          code_lens = "on";
          show_whitespaces = "all";
          indent_guides = {
            enabled = true;
            coloring = "indent_aware";
          };

          auto_update = false;
          relative_line_numbers = true;
          git.inline_blame.enabled = true;

          features = {
            edit_predictions_provider = "copilot";
          };

          file_types = {
            "GitHub Actions" = [
              ".github/workflows/*.yml"
              ".github/workflows/*.yaml"
            ];
          };

          telemetry = {
            metrics = false;
            diagnostics = false;
          };

          lsp = {
            gopls = {
              binary.path = "${pkgs.gopls}/bin/gopls";
              initialization_options = {
                gofumpt = true;
                staticcheck = true;
                analyses = {
                  ST1000 = false;
                };
              };
            };

            ruff = {
              binary.path = "${pkgs.ruff}/bin/ruff";
            };

            pyright = {
              binary.path = "${pkgs.pyright}/bin/pyright-langserver";
            };

            gleam = {
              binary = {
                path = "${pkgs.gleam}/bin/gleam";
                arguments = [ "lsp" ];
              };
            };

            buf.binary = {
              path = "${pkgs.buf}/bin/buf";
              arguments = [
                "lsp"
                "serve"
              ];
            };

            rust-analyzer = {
              binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
              initialization_options = {
                check.command = "clippy";
                rust.analyzerTargetDir = true;
              };
            };

            nixd = {
              binary.path = "${pkgs.nixd}/bin/nixd";
            };

            # Shell
            bash-language-server = {
              binary = {
                path = "${pkgs.bash-language-server}/bin/bash-language-server";
                arguments = [ "start" ];
              };
            };

            # YAML
            yaml-language-server = {
              binary = {
                path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
                arguments = [ "--stdio" ];
              };
              settings.yaml = {
                schemaStore.enable = true;
                validate = true;
              };
            };

            jj-lsp = {
              binary = {
                path = "${inputs.jj-lsp.packages.${system}.default}/bin/jj-lsp";
              };
            };

            ansible-language-server = {
              binary = {
                path = "${pkgs.ansible-language-server}/bin/ansible-language-server";
                arguments = [ "--stdio" ];
              };
            };

            terraform-ls = {
              binary = {
                path = "${pkgs.terraform-ls}/bin/terraform-ls";
                arguments = [ "serve" ];
              };
            };

            helm_ls = {
              binary = {
                path = "${pkgs.helm-ls}/bin/helm_ls";
                arguments = [ "serve" ];
              };
            };

            marksman = {
              binary = {
                path = "${pkgs.marksman}/bin/marksman";
                arguments = [ "server" ];
              };
            };
          };

          languages = {
            "*" = {
              language_servers = [
                "!.."
                "jj-lsp"
              ];
            };

            Rust = {
              language_servers = [ "rust-analyzer" ];
              format_on_save = "on";
              tab_size = 4;
            };

            Go = {
              language_servers = [ "gopls" ];
              format_on_save = "on";
              tab_size = 4;
              hard_tabs = true;
            };

            Python = {
              language_servers = [
                "pyright"
                "ruff"
              ];
              format_on_save = "on";
              tab_size = 4;
              formatter = {
                external = {
                  command = "${pkgs.ruff}/bin/ruff";
                  arguments = [
                    "format"
                    "--stdin-filename"
                    "{buffer_path}"
                    "-"
                  ];
                };
              };
            };

            Nix = {
              language_servers = [ "nixd" ];
              format_on_save = "on";
              tab_size = 2;
              formatter = {
                external = {
                  command = "${pkgs.nixfmt}/bin/nixfmt";
                };
              };
            };

            Gleam = {
              language_servers = [ "gleam" ];
              format_on_save = "on";
              tab_size = 2;
            };

            Protobuf = {
              language_servers = [ "buf" ];
              formatter = {
                external = {
                  command = "${pkgs.buf}/bin/buf";
                  arguments = [
                    "format"
                    "-w"
                  ];
                };
              };
            };

            Shell = {
              language_servers = [ "bash-language-server" ];
              format_on_save = "on";
              tab_size = 2;
              formatter = {
                external = {
                  command = "${pkgs.shfmt}/bin/shfmt";
                  arguments = [
                    "-i"
                    "2"
                    "-ci"
                  ];
                };
              };
            };

            YAML = {
              language_servers = [ "yaml-language-server" ];
              tab_size = 2;
            };

            Ansible = {
              language_servers = [ "ansible-language-server" ];
              tab_size = 2;
            };

            Terraform = {
              language_servers = [ "terraform-ls" ];
              format_on_save = "on";
              tab_size = 2;
            };

            Helm = {
              language_servers = [ "helm_ls" ];
              tab_size = 2;
            };

            Markdown = {
              language_servers = [ "marksman" ];
              tab_size = 2;
            };
          };
        };

        userKeymaps = [
          {
            bindings = {
              "cmd-alt-c" = "agent::NewTerminalThread";
            };
          }
        ];
      };
    };
}
