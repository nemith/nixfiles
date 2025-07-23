{inputs, ...}: {
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
}
