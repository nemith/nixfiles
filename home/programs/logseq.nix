{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.bbennett.programs.logseq;
in {
  options = {
    bbennett.programs.logseq = {
      enable = lib.mkEnableOption "Logseq journaling";
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default =
          if pkgs.stdenv.isLinux
          then pkgs.logseq
          else null;
        description = "Logseq package to install";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.optionals (cfg.package != null) [cfg.package];
  };
}
