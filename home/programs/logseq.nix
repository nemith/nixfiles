{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    bbennett.programs.logseq = {
      enable = lib.mkEnableOption "Logseq journaling";
    };
  };

  config = lib.mkIf config.bbennett.programs.logseq.enable {
    home.packages = with pkgs; [
      logseq
    ];
  };
}
