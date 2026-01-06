{pkgs, ...}: {
  system.primaryUser = "bbennett";
  home-manager.users.bbennett.imports = [
    ./home.nix
  ];

  programs.fish.enable = true;
  users.users.bbennett = {
    home = "/Users/bbennett";
    shell = pkgs.fish;
  };

  homebrew = {
    casks = [
      "1password"
      "google-drive"
      "slack"
    ];
  };
}
