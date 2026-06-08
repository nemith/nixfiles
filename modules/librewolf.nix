{ self, ... }: {
  flake.modules.homeManager.librewolf = { pkgs, ... }: {
    programs.librewolf = (self.lib.mkFirefoxConfig pkgs) // {
      enable = true;
      package =
        if pkgs.stdenv.isLinux then
          pkgs.librewolf.override { nativeMessagingHosts = [ pkgs.gnome-browser-connector ]; }
        else
          pkgs.librewolf;
    };
  };
}
