_: {
  flake.modules.homeManager.helix = _: {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings.editor.inline-diagnostics = {
        cursor-line = "warning";
        other-lines = "error";
      };
    };
  };
}
