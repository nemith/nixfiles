{ inputs, ... }: {
  flake.modules.homeManager.zed =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      home.packages =
        with pkgs;
        [ ioskeley-mono.normal-NF ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          (writeShellScriptBin "zed" ''
            exec zeditor --zed "$HOME/Applications/Home Manager Apps/Zed.app" "$@"
          '')
        ];

      home.shellAliases = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin { zeditor = "zed"; };

      programs.zed-editor = {
        enable = true;

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
          which_key.enabled = true;
          format_on_save = "on";
          formatter = "language_server";

          bottom_dock_layout = "right_aligned";
          buffer_font_family = "IoskeleyMono Nerd Font";
          buffer_font_size = 12;
          project_panel.dock = "left";
          agent.dock = "right";
          terminal = {
            font_family = "IoskeleyMono Nerd Font";
            dock = "bottom";
            env = {
              EDITOR = "zed --wait";
              VISUAL = "zed --wait";
              GIT_EDITOR = "zed --wait";
            };
          };
          colorize_brackets = true;
          code_lens = "on";
          show_whitespaces = "all";
          indent_guides = {
            enabled = true;
            coloring = "indent_aware";
          };

          auto_update = false;
          relative_line_numbers = "enabled";
          git.inline_blame.enabled = true;
          edit_predictions.provider = "copilot";

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
              inlay_hints.enabled = false;
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
