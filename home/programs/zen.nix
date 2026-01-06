{
  lib,
  config,
  ...
}: {
  options.bbennett.programs.zen = {
    enable = lib.mkEnableOption "zen webbrowser";
  };

  config = lib.mkIf config.bbennett.programs.zen.enable {
    programs.zen-browser.enable = true;
  };
}
