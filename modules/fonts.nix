_: {
  flake.modules.homeManager.fonts = { pkgs, ... }: {
    home.packages = with pkgs; [
      dosis
      fira-go
      maple-mono.NF
      nerd-fonts.blex-mono
      nerd-fonts.fira-code
      nerd-fonts.im-writing
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.space-mono
      nerd-fonts.terminess-ttf
      vista-fonts # consolas
    ];
  };
}
