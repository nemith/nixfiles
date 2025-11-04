{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  options.bbennett.zen = {
    enable = lib.mkEnableOption "zen webbrowser";
  };

  config = lib.mkIf config.bbennett.zen.enable {
    programs.zen-browser.enable = true;
  };
}
