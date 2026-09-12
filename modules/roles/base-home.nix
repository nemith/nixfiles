_: {
  flake.modules.homeManager.base = { pkgs, ... }: {
    services.home-manager.autoExpire.enable = true;

    # Allow home-manager to manage itself
    programs.home-manager.enable = true;

    home.packages = with pkgs; [ _1password-cli ];
  };
}
