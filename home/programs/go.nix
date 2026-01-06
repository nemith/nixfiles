{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.programs.go;
in {
  options.bbennett.programs.go = {
    enable = lib.mkEnableOption "go dev environment";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.go_1_25;
      description = "The go package to install";
      example = "pkgs.go_1_25";
    };

    goPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.local/go";
      example = "go";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "${cfg.goPath}/bin"
    ];

    home.packages = with pkgs; [
      delve
      gofumpt
      golangci-lint
      gotestsum
      gotools
    ];

    programs.go = {
      inherit (cfg) package;
      enable = true;
      env.GOPATH = cfg.goPath;
      telemetry.mode = "off";
    };
  };
}
