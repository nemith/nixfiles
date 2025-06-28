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
}
