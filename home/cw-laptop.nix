{ config, lib, pkgs, ... }:
let
  vdiHostname = "bbennett-1.tenant-coreweave-vdi.coreweave.cloud";
  vdiSSHConfig = {
    hostname = vdiHostname;
    forwardAgent = true;
  };

  # Spy on me
  netskopeCacertPath = "/Library/Application Support/Netskope/STAgent/data/nscacert.pem";
in
{
  home.sessionVariables = {
    SSL_CERT_FILE = netskopeCacertPath;
  };

  programs.git = {
    extraConfig = {
      http.sslCAInfo = netskopeCacertPath;
    };
  };

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
