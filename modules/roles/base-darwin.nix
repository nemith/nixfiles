{ self, ... }:
{
  flake.modules.darwin.base =
    { inputs, ... }:
    {
      imports = [
        self.modules.darwin.nixpkgs
        self.modules.darwin.logseq
      ];

      nix = {
        gc.automatic = true;
        optimise.automatic = true;

        linux-builder.enable = true;

        settings = {
          trusted-users = [ "@admin" ];
          "extra-experimental-features" = [
            "nix-command"
            "flakes"
          ];
        };
      };

      system.defaults = {
        dock = {
          autohide = true;
          orientation = "bottom";
          show-recents = false;
          static-only = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          FXEnableExtensionChangeWarning = false;
          CreateDesktop = false;
        };

        NSGlobalDomain = {
          "com.apple.sound.beep.feedback" = 0; # Disable beep sound
          AppleInterfaceStyle = "Dark";
          ApplePressAndHoldEnabled = false; # For key repeat in VSCode etc.
          InitialKeyRepeat = 15; # Key repeat initial delay (15 = 225ms)
          KeyRepeat = 2; # Key repeat interval (2 = 30ms)
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSWindowShouldDragOnGesture = true;
          _HIHideMenuBar = false; # Auto-hide menu bar
        };
      };

      system.startup.chime = false;

      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
      };

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "uninstall";
        };

        casks = [
          "autodesk-fusion"
          "bambu-studio"
          "bambu-studio"
          "bazecor" # Dygma keyboard utility (https://dygma.com/pages/programmable-keyboard)
          "bettermouse"
          "discord"
          "monodraw"
          "orbstack"
          "raycast"
          "rectangle"
          "utm"
          "visual-studio-code"
          "wireshark-app"
        ];
      };

      system.stateVersion = 6;
    };

  flake.modules.homeManager.darwin = _: {
    targets.darwin = {
      copyApps.enable = true;
      linkApps.enable = false;
    };
  };
}
