{
  config,
  lib,
  ...
}: let
  vdiHostname = "bbennett-1.tenant-coreweave-vdi.coreweave.cloud";
in {
  imports = [../../home/personalities/cw.nix];

  bbennett.lemonade = {
    enable = true;
    server = {
      enable = true;
    };
  };

  bbennett.ssh = {
    defaultTermEnv.excludePatterns = "!dev !vdi";
  };

  programs.ssh = {
    matchBlocks = {
      "10.* *.cwint.ai" = {
        forwardAgent = true;
        proxyJump = "vdi";
      };

      "metal-ztp*" = {
        user = "acc";
      };
      "vdi" = {
        hostname = vdiHostname;
        forwardAgent = true;
      };
      "dev" = {
        hostname = vdiHostname;
        forwardAgent = true;
        remoteForwards = lib.optionals config.bbennett.lemonade.server.enable [
          {
            bind.port = 2489;
            host.address = "localhost";
            host.port = 2489;
          }
        ];
        extraOptions = {
          RequestTTY = "yes";
          RemoteCommand = "zellij attach --create dev";
        };
      };
    };
  };

  home.stateVersion = "24.11";
}
