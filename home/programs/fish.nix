{
  lib,
  config,
  ...
}: {
  options = {
    bbennett.programs.fish.enable = lib.mkEnableOption "fish shell";
  };

  config = lib.mkIf config.bbennett.programs.fish.enable {
    home.shell = {
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
    };
  };
}
