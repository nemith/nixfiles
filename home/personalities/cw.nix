{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-cli
    doppler
    go-task
    teleport_16
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
