{lib, ...}: {
  imports = [../../home/personalities/cw.nix];
  targets.genericLinux.enable = true;

  home = {
    username = "bbennett";
    homeDirectory = "/home/bbennett";
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
    };
  };

  home.stateVersion = "24.11";
}
