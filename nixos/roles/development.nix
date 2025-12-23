{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bbennett.roles.devel.enable = lib.mkEnableOption "Enable development personality";

  config = lib.mkIf config.bbennett.roles.devel.enable {
    bbennett.services.podman.enable = lib.mkDefault true;

    environment.defaultPackages = [
      pkgs.containerlab
    ];
  };
}
