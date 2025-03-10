{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
    }:
    let
      myPackages = (
        final: prev: {
          litra-autotoggle = prev.callPackage ./pkgs/litra-autotoggle.nix { };
        }
      );
    in
    {
      homeConfigurations."bbennett@strongbad-wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ myPackages ];
        };
        modules = [
          {
            targets.genericLinux.enable = true;

            home.username = "bbennett";
            home.homeDirectory = "/home/bbennett";
          }
          ./home/home.nix
          ./home/bluecore.nix
        ];
      };

      darwinConfigurations.bbennett-MacBookPro = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ myPackages ]; }
          ./darwin/base.nix
          ./darwin/bluecore.nix
          home-manager.darwinModules.home-manager
          {
            users.users.bbennett.home = "/Users/bbennett";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bbennett = {
              imports = [
                ./home/base.nix
                ./home/bluecore.nix
                ./home/darwin.nix
              ];
            };
          }
        ];
      };
    };
}
