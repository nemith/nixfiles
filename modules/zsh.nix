_: {
  flake.modules.homeManager.zsh = { pkgs, ... }: {
    home.shell = {
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        append = true;
        extended = true;
        share = false;
        size = 200000;
        saveNoDups = true;
        findNoDups = true;
      };

      setOptions = [ "INC_APPEND_HISTORY_TIME" ];

      shellAliases = {
        path = "echo -e \${PATH//:/\\n}";
      };

      historySubstringSearch.enable = true;

      # fzf-tab: replace zsh's default completion menu with an fzf picker.
      # Must be sourced after compinit but before other widget-binding plugins,
      # which home-manager's plugin ordering handles here.
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];
    };
  };
}
