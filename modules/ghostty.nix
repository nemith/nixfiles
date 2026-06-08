_: {
  flake.modules.homeManager.ghostty = { pkgs, lib, ... }: {
    home.packages = with pkgs; [ maple-mono.NF ];

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
        keybind = [ "shift+enter=text:\n" ];
      };
    };
  };
}
