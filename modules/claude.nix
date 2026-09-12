_: {
  flake.modules.homeManager.claude = { pkgs, ... }: {
    programs.mcp.enable = true;

    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;

      lspServers = {
        go = {
          command = "${pkgs.gopls}/bin/gopls";
          args = [ "serve" ];
          extensionToLanguage.".go" = "go";
        };

        rust = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          args = [ ];
          extensionToLanguage.".rs" = "rust";
        };

        nix = {
          command = "${pkgs.nixd}/bin/nixd";
          args = [ ];
          extensionToLanguage.".nix" = "nix";
        };

        python = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
          extensionToLanguage = {
            ".py" = "python";
            ".pyi" = "python";
          };
        };

        bash = {
          command = "${pkgs.bash-language-server}/bin/bash-language-server";
          args = [ "start" ];
          extensionToLanguage = {
            ".sh" = "shellscript";
            ".bash" = "shellscript";
          };
        };

        gleam = {
          command = "${pkgs.gleam}/bin/gleam";
          args = [ "lsp" ];
          extensionToLanguage.".gleam" = "gleam";
        };

        yaml = {
          command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          args = [ "--stdio" ];
          extensionToLanguage = {
            ".yaml" = "yaml";
            ".yml" = "yaml";
          };
        };

        terraform = {
          command = "${pkgs.terraform-ls}/bin/terraform-ls";
          args = [ "serve" ];
          extensionToLanguage.".tf" = "terraform";
        };

        markdown = {
          command = "${pkgs.marksman}/bin/marksman";
          args = [ "server" ];
          extensionToLanguage.".md" = "markdown";
        };
      };

      # OpenAI's Codex plugin for Claude Code: adds /codex:review,
      # /codex:adversarial-review, and task-delegation commands that shell out
      # to the `codex` CLI (provided by the codex home-manager module).
      marketplaces.openai-codex = pkgs.fetchFromGitHub {
        owner = "openai";
        repo = "codex-plugin-cc";
        rev = "db52e28f4d9ded852ab3942cea316258ae4ef346";
        hash = "sha256-S/R4kHTcIHBcG0TRX063C7ILXZZm0oMqunchPGg6ToU=";
      };

      settings = {
        # disabled to stop the recommendation; gopls is enabled in lspServers above
        enabledPlugins."gopls-lsp@claude-plugins-official" = false;
        enabledPlugins."codex@openai-codex" = true;

        env = {
          DISABLE_AUTOUPDATER = "1";
          DISABLE_TELEMETRY = "1";
          DISABLE_ERROR_REPORTING = "1";
          _ZO_DOCTOR = "0";
        };
        permissions.defaultMode = "acceptEdits";
        includeCoAuthoredBy = false;
        cleanupPeriodDays = 30;
      };
    };
  };
}
