{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.roles.cw.enable = lib.mkEnableOption "CoreWeave personality";
  };

  config = lib.mkIf config.bbennett.roles.cw.enable {
    home.packages = with pkgs; [
      _1password-cli
      cloudsmith-cli
      doppler
      go-task
      teleport_17
      backblaze-b2
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
