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
  mkNixosConfig = {
    system,
    hostname,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ../machines/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };

  mkDarwinConfig = hostname:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = nixpkgOverlays;}
        ../darwin
        ../machines/${hostname}/darwin.nix
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
        ../machines/${hostname}/home.nix
      ];
    };
}
