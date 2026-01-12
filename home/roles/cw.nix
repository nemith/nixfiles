{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    bbennett.roles.cw.enable = lib.mkEnableOption "CoreWeave personality";
  };

  config = lib.mkIf config.bbennett.roles.cw.enable {
    home.packages = with pkgs;
      [
        _1password-cli
        cloudsmith-cli
        doppler
        go-task
        backblaze-b2
      ]
      ++ [
        inputs.nixpkgs-bcb6da.legacyPackages.${system}.teleport_15
      ];

    bbennett.programs.jujutsu = {
      user = {
        email = "bbennett@coreweave.com";
        name = "Brandon Bennett";
      };
    };

    programs.go.env.GOPRIVATE = "github.com/coreweave/*";

    programs.ssh = {
      matchBlocks = {
        "metal-ztp*" = {
          user = "acc";
        };
      };
    };
  };
}
