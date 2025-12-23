{
  pkgs,
  lib,
  config,
  ...
}: {
  options.bbennett.services.litra-autotoggle = {
    enable = lib.mkEnableOption "litra autotoggle service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.litra-autotoggle;
      description = "The litra-autotoggle package to use";
    };
  };

  config = lib.mkIf config.bbennett.services.litra-autotoggle.enable {
    home.packages = [config.bbennett.services.litra-autotoggle.package];

    launchd.agents.litra-autotoggle = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [
          "${config.bbennett.services.litra-autotoggle.package}/bin/litra-autotoggle"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${config.home.homeDirectory}/.local/state/litra-autotoggle/log";
        ThrottleInterval = 30;
      };
    };

    systemd.user.services.litra-autotoggle = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Litra autotoggle service";
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${config.bbennett.services.litra-autotoggle.package}/bin/litra-autotoggle";
        Restart = "on-failure";
        RestartSec = 30;
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
