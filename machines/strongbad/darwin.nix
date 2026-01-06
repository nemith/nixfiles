_: {
  system.primaryUser = "bbennett";
  users.users.bbennett.home = "/Users/bbennett";
  home-manager.users.bbennett.imports = [
    ./home.nix
  ];

  services.openssh = {
    enable = true;
  };

  homebrew = {
    casks = [
      "autodesk-fusion"
      "balenaetcher"
      "bitwarden"
      "ungoogled-chromium"
      "ente"
      "geekbench"
      {
        name = "librewolf";
        args.no_quarantine = true;
      }
      "orcaslicer"
      "steam"
      "vlc"
      "whatsapp"
      "wireshark"
    ];
  };
}
