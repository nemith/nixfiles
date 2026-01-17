{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bbennett.roles.gaming.enable = lib.mkEnableOption "Enable gaming personality";

  config = lib.mkIf config.bbennett.roles.gaming.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.gamemode.enable = true;
    hardware.xpadneo.enable = true;

    environment.defaultPackages = with pkgs; [
      vulkan-tools

      dsda-doom
      dsda-launcher
      dhewm3

      lutris
      wine
      winetricks
    ];
  };
}
