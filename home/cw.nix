{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    go-task
  ];

  programs.git = {
    userEmail = "bbennett@coreweave.com";
    userName = "Brandon Bennett";
  };   
}
