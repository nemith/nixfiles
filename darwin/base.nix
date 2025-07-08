{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 6;
  system.primaryUser = "bbennett";

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

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    casks = [
      "bazecor" # Dygma keyboard utility (https://dygma.com/pages/programmable-keyboar)
      "bettermouse"
      "discord"
      "ghostty"
      "logseq"
      "monodraw"
      "raycast"
      "rectangle"
      "utm"
      "visual-studio-code"
      "wireshark"
    ];

    #masApps = {
    #  "Xcode" = 497799835;
    #};
  };

  programs.fish.enable = true;
  users.users.bbennett.shell = pkgs.fish;


  nix = {
    package = pkgs.lix;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
    '';
    settings = {
      trusted-users = [ "bbennett" ];
    };
  };
}
