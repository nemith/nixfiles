{inputs, ...}: {
  flake.lib.mkFirefoxConfig = pkgs: let
    nur = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
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
        packages = with nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          gnome-shell-integration
        ];
      };
    };
  };
}
