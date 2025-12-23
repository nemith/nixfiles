{
  lib,
  config,
  pkgs,
  ...
}: {
  options.bbennett.programs.zen = {
    enable = lib.mkEnableOption "zen webbrowser";
  };

  config = lib.mkIf config.bbennett.programs.zen.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
      };
      profiles.default = {
        isDefault = true;

        settings = {
          "extensions.autoDisableScopes" = 0;
        };

        search = {
          default = "ddg";
          force = true; # Override any manual changes
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
        ];
      };
    };
  };
}
