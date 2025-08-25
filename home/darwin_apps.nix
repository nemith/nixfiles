{
  pkgs,
  lib,
  config,
  ...
}: {
  options.bbennett.darwin-apps.enable = lib.mkEnableOption "darwin-apps";

  config = lib.mkIf config.bbennett.darwin-apps.enable {
    home.packages = with pkgs; [
      discord
      logseq
      raycast
      rectangle
      utm
      wireshark
      librewolf
    ];
  };
}
