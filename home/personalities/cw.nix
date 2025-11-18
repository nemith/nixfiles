{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-cli
    cloudsmith-cli
    doppler
    go-task
    teleport_17
    backblaze-b2
  ];

  bbennett.jujutsu = {
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
}
