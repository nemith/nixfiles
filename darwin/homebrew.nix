{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    casks = [
      "bazecor" # Dygma keyboard utility (https://dygma.com/pages/programmable-keyboard)
      "bettermouse"
      "discord"
      "ghostty"
      "logseq"
      "monodraw"
      "orbstack"
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
}
