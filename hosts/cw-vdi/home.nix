{
  pkgs,
  lib,
  ...
}: {
  targets.genericLinux.enable = true;
  home.packages = with pkgs; [
    _1password-cli
    go-task
    teleport
  ];

  home = {
    username = "bbennett";
    homeDirectory = "/home/bbennett";
  };

  bbennett.jujutsu = {
    enable = true;
    user = {
      email = "bbennett@coreweave.com";
      name = "Brandon Bennett";
    };
  };

  bbennett.lemonade = {
    enable = true;
    pbAliases = true;
    browserEnv = true;
  };

  programs.ssh = {
    extraConfig = lib.concatStringsSep "\n" [
      "CanonicalDomains cwint.ai"
      "CanonicalizeHostname always"
    ];

    matchBlocks = {
      "10.* *.cwint.ai" = {
        forwardAgent = true;
      };

      "metal-ztp*" = {
        user = "acc";
      };
    };
  };
}
