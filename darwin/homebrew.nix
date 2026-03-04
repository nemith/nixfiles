_: {
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
      "cockroachdb/tap/cockroach"
      "cockroachdb/tap/cockroach-sql"
      "discord"
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
