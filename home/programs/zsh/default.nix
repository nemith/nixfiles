{
  lib,
  config,
  ...
}: {
  options = {
    bbennett.programs.zsh.enable = lib.mkEnableOption "zsh shell";
  };

  config = lib.mkIf config.bbennett.programs.zsh.enable {
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
      initContent = builtins.readFile ./init.zshrc;
    };
  };
}
