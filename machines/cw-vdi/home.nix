{
  pkgs,
  lib,
  ...
}: {
  targets.genericLinux.enable = true;
  nix.package = pkgs.lixPackageSets.stable.lix;

  home.packages = with pkgs; [
    _1password-cli
    go-task
    teleport_16
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

  programs.go.goPrivate = [
    "github.com/coreweave/*"
  ];

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

  home.stateVersion = "24.11";
}
