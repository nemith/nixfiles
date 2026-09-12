_: {
  flake.modules.homeManager.codex = _: {
    programs.mcp.enable = true;

    programs.codex = {
      enable = true;
      enableMcpIntegration = true;
    };
  };
}
