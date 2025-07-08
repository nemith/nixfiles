{
  services.openssh = {
    enable = true;
  };

  homebrew = {
    casks = [
      "autodesk-fusion"
      "balenaetcher"
      "bitwarden"
      "cursor"
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
