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

    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    mac-app-util.url = "github:hraban/mac-app-util";
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
    in
    {
      darwinConfigurations = {
        strongbad = lib.mkDarwinConfig "strongbad";
        CW-HM9D4MQMW2-L = lib.mkDarwinConfig "cw-laptop";
      };

      homeConfigurations = {
        "bbennett@bbennett-1" = lib.mkHomeConfig {
          hostname = "bbennett-1";
          system = "x86_64-linux";
        };
      };

      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
    };
}
