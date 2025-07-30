{
  inputs,
  overlays,
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin;
  nixpkgOverlays = [
    overlays.myPackages
    inputs.nur.overlays.default
  ];
in {
  mkDarwinConfig = hostname:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = nixpkgOverlays;}
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
        overlays = nixpkgOverlays;
      };
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ../home
        ../hosts/${hostname}/home.nix
      ];
    };
}
