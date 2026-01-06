{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    bbennett.programs.zed-editor.enable = lib.mkEnableOption "zed-editor";
  };

  config = lib.mkIf config.bbennett.programs.zed-editor.enable {
    home.packages = with pkgs; [
      maple-mono.NF
    ];

    programs.zed-editor = {
      enable = true;
      userSettings = {
        vim_mode = true;

        buffer_font_size = 12;
        buffer_font_family = "Maple Mono NF";
      };
    };
  };
}
