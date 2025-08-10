{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.ssh;
in {
  options.bbennett.ssh = {
    enable = lib.mkEnableOption "ssh client";

    defaultTermEnv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.bbennett.ghostty.enable or false;
        description = "Enable default terminal environment settings (defaults to ghostty.enable value)";
      };

      termEnv = lib.mkOption {
        type = lib.types.str;
        default = "xterm-256color";
        description = "Terminal type to set for SSH connections";
      };

      excludePatterns = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Pattern to exclude from terminal type setting (e.g., '!dev !staging')";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      sshpass
    ];

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = lib.concatStringsSep "\n" (
        lib.optional pkgs.stdenv.isDarwin "UseKeychain yes"
      );

      matchBlocks = lib.mkIf cfg.defaultTermEnv.enable {
        "* ${cfg.defaultTermEnv.excludePatterns}".setEnv = {
          TERM = cfg.defaultTermEnv.termEnv;
        };
      };
    };
  };
}
