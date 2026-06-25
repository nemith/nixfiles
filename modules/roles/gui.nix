{self, ...}: {
  flake.modules.homeManager.gui = {pkgs, ...}: {
    imports = [
      self.modules.homeManager.fonts
      self.modules.homeManager.ghostty
      self.modules.homeManager.librewolf
      self.modules.homeManager.logseq
      self.modules.homeManager.zen
      self.modules.homeManager.litra-autotoggle
    ];

    home.packages = with pkgs;
      [wireshark]
      ++ lib.optionals pkgs.stdenv.isLinux [
        bambu-studio
        bazecor
        cider-2
        orca-slicer
        ungoogled-chromium
      ];
  };
}
