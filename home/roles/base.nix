{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.roles.base.enable = lib.mkEnableOption "base personality" // {default = true;};
  };

  config = lib.mkIf config.bbennett.roles.base.enable {
    bbennett.programs = {
      neovim.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
      zellij.enable = lib.mkDefault true;
    };

    catppuccin.enable = true;

    targets.darwin = lib.mkIf pkgs.stdenv.isDarwin {
      copyApps.enable = true;
      linkApps.enable = false;
    };

    services = {
      home-manager.autoExpire.enable = true;
    };

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}
