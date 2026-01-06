{
  lib,
  config,
  ...
}: {
  options.bbennett.programs.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.bbennett.programs.zellij.enable {
    programs.zellij = {
      enable = true;
      settings = {
        default_layout = "compact";
        ui.pane_frames = {
          rounded_corners = true;
        };
        pane_viewport_serialization = true;
        default_shell = "zsh";
        plugins = {
          compact-bar = {
            location = "zellij:compact-bar";
            tooltip = "F1";
          };
        };
      };
    };
  };
}
