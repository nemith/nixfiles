{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.programs.jule;
in {
  options.bbennett.programs.jule = {
    enable = lib.mkEnableOption "jule dev environment";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      julec
      julefmt
      juledoc
    ];
  };
}
