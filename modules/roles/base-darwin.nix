{ self, ... }: {
  flake.modules.darwin.base = { inputs, ... }: {
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

      # Disable Spotlight's Cmd-Space so Raycast can take it over.
      # (Set Cmd-Space as Raycast's hotkey inside the Raycast app itself.)
      CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys."64".enabled = false;

      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0; # Disable beep sound
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false; # For key repeat in editors
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

    # nix-darwin manages Homebrew packages but doesn't add its bin dirs to the
    # PATH; do it explicitly (Apple Silicon prefix).
    environment.systemPath = [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "uninstall";
        extraFlags = [
          "--force-cleanup" # Workaround for https://github.com/nix-darwin/nix-darwin/issues/1787
        ];
      };

      casks = [
        "autodesk-fusion"
        "bambu-studio"
        "bazecor" # Dygma keyboard utility (https://dygma.com/pages/programmable-keyboard)
        "bettermouse"
        "chatgpt"
        "claude"
        "discord"
        "lm-studio"
        "monodraw"
        "orbstack"
        "raycast"
        "rectangle"
        "utm"
        "whatsapp"
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
