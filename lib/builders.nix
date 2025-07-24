{
  inputs,
  overlays,
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin;
in {
  mkDarwinConfig = hostname:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = [overlays.myPackages];}
        ../darwin
        ../hosts/${hostname}/darwin.nix
      ];
    };

  mkHomeConfig = {
    system,
    hostname,
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [overlays.myPackages];
      };
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ../home
        ../hosts/${hostname}/home.nix
      ];
    };
}
