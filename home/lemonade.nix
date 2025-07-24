{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.lemonade;

  lemonadeServerArgs = let
    baseArgs = ["${cfg.package}/bin/lemonade" "server"];
    portArgs = ["--port" (toString cfg.server.settings.port)];
    hostArgs = ["--host" cfg.server.settings.host];
    logArgs = ["--log-level" (toString cfg.server.settings.logLevel)];
    allowArgs = lib.optionals (cfg.server.settings.allow != []) ["--allow" (lib.concatStringsSep "," cfg.server.settings.allow)];
  in
    baseArgs ++ portArgs ++ hostArgs ++ allowArgs ++ logArgs ++ cfg.server.settings.extraArgs;
in {
  options.bbennett.lemonade = {
    enable = lib.mkEnableOption "lemonade";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.lemonade;
      defaultText = lib.literalExpression "pkgs.lemonade";
      description = "The lemonade package to use.";
    };

    pbAliases = lib.mkEnableOption "enable aliases for pbcopy/pbpaste";

    browserEnv = lib.mkEnableOption "enable BROWSER environment variable";

    server = {
      enable = lib.mkEnableOption "lemonade server";
      settings = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Host to bind to.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 2489;
          description = "Port to listen on.";
        };

        allow = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          # applications default is actually 0.0.0.0/0 but we aint doing that.
          default = ["127.0.0.1/32" "::1/128"];
          description = "List of allowed IP addresses/ranges.";
        };

        logLevel = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Log level [4 = Critical, 0 = Debug]";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Extra arguments to pass to lemonade server.";
        };
      };
    };
  };
  config = lib.mkIf config.bbennett.lemonade.enable {
    home.packages = [cfg.package];

    home.shellAliases = lib.mkIf cfg.pbAliases {
      pbcopy = "${cfg.package}/bin/lemonade copy";
      pbpaste = "${cfg.package}/bin/lemonade paste";
    };

    home.sessionVariables = lib.mkIf cfg.browserEnv {
      "BROWSER" = "${cfg.package}/bin/lemonade open";
    };

    launchd.agents.lemonade = lib.mkIf (pkgs.stdenv.isDarwin && cfg.server.enable) {
      enable = true;
      config = {
        ProgramArguments = lemonadeServerArgs;
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.xdg.cacheHome}/lemonade/lemonade.log";
      };
    };
  };
}
