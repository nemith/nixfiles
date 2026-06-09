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

      settings = {
        env = {
          DISABLE_AUTOUPDATER = "1";
          DISABLE_TELEMETRY = "1";
          DISABLE_ERROR_REPORTING = "1";
        };
        permissions.defaultMode = "acceptEdits";
        includeCoAuthoredBy = false;
        cleanupPeriodDays = 30;
      };
    };
  };
}
