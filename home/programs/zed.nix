{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.programs.vscode;
in {
  options.bbennett.programs.zed = {
    enable = lib.mkEnableOption "zed";
  };

  config = lib.mkIf cfg.enable {
    # make sure our desired font is installed
    home.packages = with pkgs; [maple-mono.NF];

    programs.zed-editor = {
      enable = true;
    };
  };
}
