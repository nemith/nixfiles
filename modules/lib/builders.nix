_: {
  flake.lib.mkFirefoxConfig =
    pkgs:
    let
      addons = pkgs.nur.repos.rycee.firefox-addons;
    in
    {
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
          force = true;
        };
        extensions = {
          force = true;
          packages = with addons; [
            ublock-origin
            addons."1password-x-password-manager"
            gnome-shell-integration
          ];
        };
      };
    };
}
