_: {
  flake.modules.homeManager.zsh = _: {
    home.shell = {
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;

      history = {
        append = true;
        extended = true;
      };

      shellAliases = {
        path = "echo -e \${PATH//:/\\n}";
      };

      historySubstringSearch.enable = true;
    };
  };
}
