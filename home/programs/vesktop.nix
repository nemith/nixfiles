{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    bbennett.programs.vesktop.enable = lib.mkEnableOption "vesktop";
  };

  config = lib.mkIf (config.bbennett.programs.vesktop.enable && pkgs.stdenv.hostPlatform.isLinux) {
    home.packages = with pkgs; [
      vesktop
    ];
  };
}
