{
  config,
  lib,
  ...
}: {
  options.bbennett.roles.laptop.enable = lib.mkEnableOption "Enable laptop personality";

  config = lib.mkIf config.bbennett.roles.laptop.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };

    services.power-profiles-daemon.enable = true;
    powerManagement.enable = true;
  };
}
