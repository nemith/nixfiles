{...}: {
  system.primaryUser = "bbennett";
  users.users.bbennett.home = "/Users/bbennett";
  home-manager.users.bbennett.imports = [
    ./home.nix
    ../../home
  ];

  homebrew = {
    casks = [
      "1password"
      "google-drive"
      "slack"
    ];
  };
}
