{
  config,
  pkgs,
  lib,
  ...
}: let
  vdiHostname = "bbennett-1.tenant-coreweave-vdi.coreweave.cloud";
in {
  home.packages = with pkgs; [
    _1password-cli
    go-task
    teleport
  ];

  bbennett.jujutsu = {
    enable = true;
    user = {
      email = "bbennett@coreweave.com";
      name = "Brandon Bennett";
    };
  };

  bbennett.lemonade = {
    enable = true;
    server = {
      enable = true;
    };
  };

  programs.ssh = {
    matchBlocks = {
      "* !dev !vdi".setEnv = {
        TERM = "xterm-256color";
      };

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
}
