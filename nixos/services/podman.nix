{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bbennett.services.podman.enable = lib.mkEnableOption "Enable podman container runtime";

  config = lib.mkIf config.bbennett.services.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      podman-desktop
      docker-compose
      # podman-compose
    ];

    virtualisation.containers = {
      enable = true;
      storage.settings = {
        storage = {
          driver = "btrfs";
        };
      };
    };
  };
}
