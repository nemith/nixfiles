{pkgs, ...}: {
  #  bbennett.litra.enable = lib.mkIf pkgs.stdenv.isDarwin (lib.mkDefault true);
  bbennett = {
    ghostty.enable = true;
    vscode.enable = true;
    zen.enable = true;
    logseq.enable = true;
  };

  home.packages = with pkgs; [
    bambu-studio
    bazecor
    ungoogled-chromium
    cider-2
    wireshark
    orca-slicer
  ];

  programs.discord.enable = true;
  programs.librewolf.enable = true;
}
