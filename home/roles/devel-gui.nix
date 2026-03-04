{
  lib,
  config,
  ...
}: {
  options = {
    bbennett.roles.devel-gui.enable = lib.mkEnableOption "development gui role";
  };

  config = lib.mkIf config.bbennett.roles.devel-gui.enable {
    bbennett.programs.vscode.enable = lib.mkDefault true;
  };
}
