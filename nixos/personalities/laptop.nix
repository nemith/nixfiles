{
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
}
