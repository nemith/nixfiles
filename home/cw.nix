{ config, lib, pkgs, ... }:
let
  cwEmail = "bbennett@coreweave.com";
in
{
  home.packages = with pkgs; [
    _1password-cli
    go-task
  ];

  programs.git.userEmail = cwEmail;
  programs.jujutsu.settings.user.email = cwEmail;

  programs.ssh = {
    matchBlocks = {
      "* !dev !vdi".setEnv = {
        TERM = "xterm-256color";
      };

      "10.* cwint.ai" = {
        forwardAgent = true;
        setEnv = {
          # Explicitly set the TERM as we are not going to poke the termcaps of
          # routers/switches for ghostty.
          TERM = "xterm-256color";
        };
      };

      "metal-ztp*" = {
        user = "acc";
      };
    };
  };
}
