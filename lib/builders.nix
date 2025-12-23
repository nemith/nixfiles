{
  inputs,
  overlays,
}: let
  inherit (inputs) nixpkgs home-manager nix-darwin;
  nixpkgOverlays = [
    overlays
    inputs.nur.overlays.default
  ];

  homeManagerSharedModules = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nixCats.homeModule
    inputs.zen-browser.homeModules.default
    ../home
  ];

  homeManagerConfig = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = homeManagerSharedModules;
  };
in {
  mkNixosConfig = {
    system,
    hostname,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = nixpkgOverlays;}
        home-manager.nixosModules.home-manager
        {home-manager = homeManagerConfig;}
        ../nixos
        ../machines/${hostname}/configuration.nix
      ];
    };

  mkDarwinConfig = hostname:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = nixpkgOverlays;}
        home-manager.darwinModules.home-manager
        {home-manager = homeManagerConfig;}
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
      modules =
        homeManagerSharedModules
        ++ [
          ../machines/${hostname}/home.nix
        ];
    };
}
