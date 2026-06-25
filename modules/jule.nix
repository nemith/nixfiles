_: {
  flake.modules.homeManager.jule = {pkgs, ...}: {
    home.packages = with pkgs; [
      julec
      julefmt
      juledoc
    ];
  };
}
