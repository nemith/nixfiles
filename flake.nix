{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # reference for teleport_15
    nixpkgs-bcb6da.url = "github:nixos/nixpkgs/f3a2a0601e9669a6e38af25b46ce6c4563bcb6da";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = import ./lib {inherit inputs;};
    supportedSystems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    nixosConfigurations = {
      devvm = lib.mkNixosConfig {
        hostname = "cw-laptop-devvm";
        system = "aarch64-linux";
      };
    };

    darwinConfigurations = {
      strongbad = lib.mkDarwinConfig "strongbad";
      CW-HM9D4MQMW2-L = lib.mkDarwinConfig "cw-laptop";
    };

    homeConfigurations = {
      "bbennett@bbennett-1" = lib.mkHomeConfig {
        hostname = "cw-vdi";
        system = "x86_64-linux";
      };
    };

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    checks = forAllSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          end-of-file-fixer.enable = true;
          trim-trailing-whitespace.enable = true;
        };
      };
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs =
          (with pkgs; [
            statix
          ])
          ++ self.checks.${system}.pre-commit-check.enabledPackages;
      };
    });
  };
}
