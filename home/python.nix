{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.python;

  mkPythonPackages = {
    primary,
    others,
  }:
    [(lib.meta.hiPrio primary)]
    ++ (lib.imap1 (i: pkg: lib.meta.setPrio i pkg) others);
in {
  options.bbennett.python = {
    enable = lib.mkEnableOption "python dev environment";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python313;
      description = "The preferred Python version (highest priority)";
      example = "pkgs.python313";
    };

    other_packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [python314 python312 python311 python310];
      description = "Other Python versions to install (lower priority)";
      example = "with pkgs; [ python314 python312 python311 ]";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        pre-commit
        uv
        poetry
      ]
      ++ (mkPythonPackages {
        primary = cfg.package;
        others = cfg.other_packages;
      });

    home.sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib/";
    };

    programs.ruff = {
      enable = true;
      settings = {};
    };
  };
}
