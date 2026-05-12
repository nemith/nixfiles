_: {
  flake.modules.homeManager.zellij = _: {
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
