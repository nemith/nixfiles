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

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-darwin
    , mac-app-util
    , ...
    }@inputs:
    let
      myPackages = (
        final: prev: {
          litra-autotoggle = prev.callPackage ./pkgs/litra-autotoggle.nix { };
        }
      );

      mkDarwinConfig = { username, extraDarwinModules ? [ ], extraHomeModules ? [ ] }:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = [ myPackages ]; }
            mac-app-util.darwinModules.default
            ./darwin/base.nix
            home-manager.darwinModules.home-manager
            {
              users.users.${username}.home = "/Users/${username}";
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${username} = {
                imports = [
                  ./home/base.nix
                  ./home/darwin.nix
                ] ++ extraHomeModules;
              };
            }
          ] ++ extraDarwinModules;
        };
    in
    {
      # cw dev server
      homeConfigurations."bbennett@bbennett-1" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ myPackages ];
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          {
            targets.genericLinux.enable = true;

            home.username = "bbennett";
            home.homeDirectory = "/home/bbennett";
          }
          ./home/base.nix
          ./home/cw.nix
          ./home/cw-vdi.nix
        ];
      };

      darwinConfigurations.strongbad = mkDarwinConfig {
        username = "bbennett";
        extraDarwinModules = [
          ./darwin/personal.nix
        ];
      };

      darwinConfigurations.CW-HM9D4MQMW2-L = mkDarwinConfig {
        username = "bbennett";
        extraDarwinModules = [
          ./darwin/cw.nix
        ];
        extraHomeModules = [
          ./home/cw.nix
          ./home/cw-laptop.nix
        ];
      };
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

    };
}
