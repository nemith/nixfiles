_: {
  flake.modules.homeManager.pkl =
    { pkgs, ... }:
    let
      jdk = "${pkgs.pkl.passthru.jdk or pkgs.temurin-bin-21}";
    in
    {
      home.packages = [
        pkgs.pkl
        jdk
      ];
    };
}
