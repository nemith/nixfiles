{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bbennett.aerospace.enable = lib.mkEnableOption "aerospace wm";

  config = lib.mkIf config.bbennett.aerospace.enable {
    home.packages = [ pkgs.aerospace ];

    programs.aerospace = {
      enable = true;
      userSettings = {
        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };
      };
    };

    services.jankyborders = {
      enable = true;
      settings = {
        style = "round";
        width = 6.0;
      };
    };
  };
}
