{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    bbennett.logseq = {
      enable = lib.mkEnableOption "Logseq journaling";
    };
  };

  config = lib.mkIf config.bbennett.logseq.enable {
    home.packages = with pkgs; [
      logseq
    ];
  };
}
