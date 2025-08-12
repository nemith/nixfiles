_: {
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
      {
        name = "librewolf";
        args.no_quarantine = true;
      }
    ];

    #masApps = {
    #  "Xcode" = 497799835;
    #};
  };
}
