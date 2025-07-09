{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    teleport
  ];

  programs.jujutsu = {
    settings = {
      user = {
        email = lib.mkDefault "bbennett@coreweave.com";
        name = lib.mkDefault "Brandon Bennett";
      };
    };
  };

  programs.ssh = {
    addKeysToAgent = "yes";
    matchBlocks = {
      "metal-ztp*" = {
        user = "acc";
      };
    };
  };

}
