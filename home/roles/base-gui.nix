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
    bbennett.programs.ghostty.enable = lib.mkDefault true;
    bbennett.programs.librewolf.enable = lib.mkDefault true;
    bbennett.programs.logseq.enable = lib.mkDefault true;
    bbennett.programs.vesktop.enable = lib.mkDefault true;
    bbennett.programs.zen.enable = lib.mkDefault true;

    bbennett.services.litra-autotoggle.enable = lib.mkDefault true;

    home.packages = with pkgs;
      [
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

        wireshark
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # Source build of bambu-studio is badly broken
        # See https://github.com/NixOS/nixpkgs/issues/440951
        #bambu-studio
        nur.repos.xddxdd.bambu-studio-bin

        bazecor
        cider-2
        orca-slicer
        ungoogled-chromium
      ];
  };
}
