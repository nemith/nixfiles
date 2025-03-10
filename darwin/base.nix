{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;


  system.stateVersion = 6;
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
      AppleInterfaceStyle = "Dark";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      _HIHideMenuBar = false; # Auto-hide menu bar
      "com.apple.sound.beep.feedback" = 0; # Disable beep sound
      ApplePressAndHoldEnabled = false; # For key repeat in VSCode etc.
      InitialKeyRepeat = 15; # Key repeat initial delay (15 = 225ms)
      KeyRepeat = 2; # Key repeat interval (2 = 30ms)
    };
  };

  system.startup.chime = false;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  security.sudo.extraConfig = ''
    %admin ALL=(ALL:ALL) NOPASSWD: ${config.system.build.darwin-rebuild}/bin/darwin-rebuild
    '';


  services = {
    openssh.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    casks = [
      "alt-tab"
      "autodesk-fusion"
      "balenaetcher"
      "bettermouse"
      "bitwarden"
      "discord"
      "docker"
      "ente"
      "firefox"
      "geekbench"
      "ghostty"
      "gimp"
      "google-drive"
      "istat-menus"
      "iterm2"
      {
        name = "librewolf";
	args.no_quarantine = true;
      }
      "logseq"
      "menuwhere"
      "orcaslicer"
      "raycast"
      "rectangle"
      "steam"
      "utm"
      "visual-studio-code"
      "vivaldi"
      "vlc"
      "whatsapp"
      "wireshark"
    ];

    masApps = {
      "Xcode" = 497799835;
    };
  };

  
  nix = {
    package = pkgs.lix;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      # auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };
}
