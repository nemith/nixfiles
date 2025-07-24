{
  pkgs,
  lib,
  config,
  ...
}: {
  options.bbennett.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf config.bbennett.ghostty.enable {
    # make sure our desired font is installed
    home.packages = with pkgs; [
      nerd-fonts.meslo-lg
    ];

    programs.ghostty = {
      enable = true;

      # Don't install the package on Darwin since it is broken.  This assumes
      # it has been installed via homebrew.
      package = lib.mkIf pkgs.stdenv.isDarwin null;

      settings = {
        font-size = 12;
        font-family = "MesloLGMDZ Nerd Font Mono";
        font-thicken = true;
        font-thicken-strength = 192;
        adjust-cell-width = -1;
      };
    };
  };
}
