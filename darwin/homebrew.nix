_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    taps = [
      "cockroachdb/tap"
    ];

    brews = [
      "cockroachdb/tap/cockroach"
      "cockroachdb/tap/cockroach-sql"
    ];

    casks = [
      "autodesk-fusion"
      "bambu-studio"
      "bambu-studio"
      "bazecor" # Dygma keyboard utility (https://dygma.com/pages/programmable-keyboard)
      "bettermouse"
      "discord"
      "logseq"
      "monodraw"
      "orbstack"
      "raycast"
      "rectangle"
      "utm"
      "visual-studio-code"
      "wireshark-app"
    ];

    #masApps = {
    #  "Xcode" = 497799835;
    #};
  };
}
