{ config, lib, pkgs, ... }:
let
  vdiHostname = "bbennett-1.tenant-coreweave-vdi.coreweave.cloud";
  vdiSSHConfig = {
    hostname = vdiHostname;
    forwardAgent = true;
  };
in
{
  programs.ssh = {
    addKeysToAgent = "yes";

    matchBlocks = {
      "vdi" = vdiSSHConfig;
      "dev" = lib.recursiveUpdate vdiSSHConfig {
        extraOptions = {
          RequestTTY = "yes";
          RemoteCommand = "zellij attach --create dev";
        };
      };
      "10.* *.cwint.ai" = {
        forwardAgent = true;
        proxyJump = "vdi";
      };
    };
  };
}
