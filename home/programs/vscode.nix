{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.programs.vscode;
in {
  options.bbennett.programs.vscode = {
    enable = lib.mkEnableOption "vscode";
  };

  config = lib.mkIf cfg.enable {
    # make sure our desired font is installed
    home.packages = with pkgs; [maple-mono.NF];

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          aaron-bond.better-comments
          bbenoist.nix
          charliermarsh.ruff
          foxundermoon.shell-format
          github.copilot
          github.copilot-chat
          github.vscode-github-actions
          golang.go
          jnoortheen.nix-ide
          kamadorueda.alejandra
          ms-azuretools.vscode-containers
          ms-azuretools.vscode-docker
          ms-python.python
          ms-vscode-remote.vscode-remote-extensionpack
          ms-vscode.cpptools
          redhat.vscode-yaml
          rust-lang.rust-analyzer
          stkb.rewrap
          timonwong.shellcheck
          visualjj.visualjj
          vscodevim.vim
        ];
        userSettings = {
          "github.copilot.nextEditSuggestions.enabled" = true;
          "editor.fontFamily" = "Maple Mono NF, MesloLGMDZ Nerd Font Mono, Menlo, Monaco, 'Courier New', monospace";
          "redhat.telemetry.enabled" = false;
          "[python]" = {
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "charliermarsh.ruff";
          };
          "claudeCode.useTerminal" = true;
        };
      };
    };
  };
}
