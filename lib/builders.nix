{ inputs, overlays }:
let
  inherit (inputs) nixpkgs home-manager nix-darwin;
in
{
  mkDarwinConfig = hostName:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.overlays = [ overlays.myPackages ]; }
        ../darwin
        ../hosts/${hostName}/darwin.nix
      ];
    };

  mkHomeConfig = { system, hostName }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlays.myPackages ];
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ../home
        ../hosts/${hostName}/home.nix
      ];
    };
}
