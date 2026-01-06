{lib, ...}: {
  targets.genericLinux.enable = true;

  bbennett.roles = {
    cw.enable = true;
    devel.enable = true;
  };

  home = {
    username = "bbennett";
    homeDirectory = "/home/bbennett";
  };

  bbennett.programs.lemonade = {
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
    };
  };

  home.stateVersion = "24.11";
}
