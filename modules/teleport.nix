{ inputs, ... }:
{
  flake.modules.homeManager.teleport =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      package = inputs.nixpkgs_teleport_16.legacyPackages.${system}.teleport_16;
    in
    {
      home.packages = [ package ];
    };
}
