{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.roles.base-gui.enable = lib.mkEnableOption "gui base";
  };

  config = lib.mkIf config.bbennett.roles.base-gui.enable {
    bbennett.programs.litra.enable = lib.mkDefault true;
    bbennett.programs.ghostty.enable = lib.mkDefault true;
    bbennett.programs.zen.enable = lib.mkDefault true;

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
