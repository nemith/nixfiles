{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    go-task
    teleport
  ];

  programs.git = {
    userEmail = "bbennett@coreweave.com";
    userName = "Brandon Bennett";
  };   

  programs.ssh = {
    matchBlocks = {
      "vdi devvm" = {
        hostname = "bbennett-1.tenant-coreweave-vdi.coreweave.cloud";
        forwardAgent = true;
      };
      "10.*" = {
        forwardAgent = true;
        setEnv = {
          # Explicitly set the TERM as we are not going to poke the termcaps of
          # routers/switches for ghostty.
          TERM = "xterm-256color";
        };
      };
    };
  };
}
