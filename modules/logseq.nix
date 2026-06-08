_: {
  flake.modules.darwin.logseq = _: { homebrew.casks = [ "logseq" ]; };

  flake.modules.homeManager.logseq = { lib, pkgs, ... }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.logseq ];
  };
}
