{
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
    };
  };
  security.pam.enableSudoTouchIdAuth = true;

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
      "brave-browser"
      "discord"
      "docker"
      "ente"
      "firefox"
      "font-blex-mono-nerd-font"
      "font-consolas-for-powerline"
      "font-dosis"
      "font-fira-code"
      "font-firago"
      "font-ia-writer-mono"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-meslo-for-powerline"
      "geekbench"
      "ghostty"
      "gimp"
      "google-drive"
      "istat-menus"
      "iterm2"
      "karabiner-elements"
      "logseq"
      "menuwhere"
      "orcaslicer"
      "raycast"
      "rectangle"
      "steam"
      "unnaturalscrollwheels"
      "utm"
      "visual-studio-code"
      "vlc"
      "whatsapp"
      "wireshark"
    ];
  };
}
