_: {
  flake.modules.homeManager.opencode = { pkgs, ... }: {
    programs.mcp.enable = true;

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
    };

    # Authenticate opencode's native Anthropic provider with existing Claude
    # Code (Pro/Max) credentials instead of an API key. Referencing the nixpkgs
    # build from the store avoids opencode fetching the plugin from npm via bun
    # at startup (the README's `"plugin": ["opencode-claude-auth@latest"]`).
    # The single re-export file pulls in the rest of the package via relative
    # imports that resolve inside the store path.
    xdg.configFile."opencode/plugins/claude-auth.js".source =
      "${pkgs.opencode-claude-auth}/lib/node_modules/opencode-claude-auth/claude-auth-plugin.js";
  };
}
