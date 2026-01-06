{
  pkgs,
  lib,
  config,
  ...
}: {
  options.bbennett.programs.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf config.bbennett.programs.ghostty.enable {
    # make sure our desired font is installed
    home.packages = with pkgs; [maple-mono.NF];

    programs.ghostty = {
      enable = true;

      # This uses the precompiled version on darwin
      package = lib.mkIf pkgs.stdenv.isDarwin pkgs.ghostty-bin;

      settings = {
        font-size = 12;
        font-family = "Maple Mono NF";
        font-thicken = true;
        font-thicken-strength = 192;
        adjust-cell-width = -1;
        keybind = [
          "shift+enter=text:\n"
        ];
      };
    };
  };
}
