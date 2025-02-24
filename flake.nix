{
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
    }:
    {
      homeConfigurations."bbennett@strongbad-wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
          ./darwin/base.nix
          home-manager.darwinModules.home-manager
          {
            users.users.bbennett.home = "/Users/bbennett";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bbennett =
              { ... }:
              {
                imports = [
                  ./home/base.nix
                  ./home/bluecore.nix
                ];
              };
          }
        ];
      };
    };
}
