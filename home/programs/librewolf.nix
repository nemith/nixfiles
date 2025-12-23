{
  lib,
  config,
  pkgs,
  ...
}: {
  options.bbennett.programs.librewolf = {
    enable = lib.mkEnableOption "librewolf webbrowser";
  };

  config = lib.mkIf config.bbennett.programs.librewolf.enable {
    programs.librewolf = {
      enable = true;
      package =
        if pkgs.stdenv.isLinux
        then
          pkgs.librewolf.override {
            nativeMessagingHosts = [
              pkgs.gnome-browser-connector
            ];
          }
        else pkgs.librewolf;

      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
      };

      profiles.default = {
        isDefault = true;

        settings = {
          "extensions.autoDisableScopes" = 0;
          "privacy.resistFingerprinting" = false;
          "webgl.disabled" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        };

        search = {
          default = "ddg";
          force = true; # Override any manual changes
        };

        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            gnome-shell-integration
          ];
        };
      };
    };
  };
}
