{
  pkgs,
  lib,
  config,
  ...
}: let
  cwEmail = "bbennett@coreweave.com";
  cfg = config.bbennett.work;
in {
  options.bbennett.work = {
    enable = lib.mkEnableOption "Work settings";

    flavor = lib.mkOption {
      type = lib.types.enum ["vdi" "laptop"];
      description = "Flavor of works system";
    };

    vdiHostname = lib.mkOption {
      type = lib.types.str;
      description = "VDI Hostname";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password-cli
      go-task
    ];

    programs.git.userEmail = cwEmail;
    programs.jujutsu.settings.user.email = cwEmail;

    programs.ssh = {
      extraConfig = lib.concatStringsSep "\n" [
        "CanonicalDomains cwint.ai"
        "CanonicalizeHostname always"
      ];
      matchBlocks = {
        "vdi" = {
          hostname = cfg.vdiHostname;
          forwardAgent = true;
        };

        "dev" = {
          hostname = cfg.vdiHostname;
          forwardAgent = true;
          extraOptions = {
            RequestTTY = "yes";
            RemoteCommand = "zellij attach --create dev";
          };
        };

        "* !dev !vdi".setEnv = {
          TERM = "xterm-256color";
        };

        "10.* *.cwint.ai" =
          {
            forwardAgent = true;
          }
          // lib.optionalAttrs (cfg.flavor == "laptop") {
            proxyJump = "vdi";
          };

        "metal-ztp*" = {
          user = "acc";
        };
      };
    };
  };
}
