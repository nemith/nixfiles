_: {
  flake.modules.homeManager.ghostty = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [ioskeley-mono.normal-term-NF];

    programs.ghostty = {
      enable = true;

      # This uses the precompiled version on darwin
      package = lib.mkIf pkgs.stdenv.isDarwin pkgs.ghostty-bin;

      settings = {
        font-size = 12;
        font-family = "IoskeleyMonoTerm Nerd Font";
        font-thicken = true;
        font-thicken-strength = 192;
        adjust-cell-width = -1;
        keybind = ["shift+enter=text:\\n"];
      };
    };
  };
}
