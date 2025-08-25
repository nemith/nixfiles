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
      "monodraw"
      "orbstack"
    ];

    #masApps = {
    #  "Xcode" = 497799835;
    #};
  };
}
