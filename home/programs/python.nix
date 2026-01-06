{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.programs.python;

  mkPythonPackages = {
    primary,
    others,
  }:
    [(lib.meta.hiPrio primary)]
    ++ (lib.imap1 (i: pkg: lib.meta.setPrio i pkg) others);
in {
  options.bbennett.programs.python = {
    enable = lib.mkEnableOption "python dev environment";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python314;
      description = "The preferred Python version (highest priority)";
      example = "pkgs.python314";
    };

    other_packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [python315 python313 python312 python311 python310];
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

    programs.ruff = {
      enable = true;
      settings = {};
    };
  };
}
