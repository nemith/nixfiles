_: {
  flake.modules.homeManager.base = _: {
    services.home-manager.autoExpire.enable = true;

    # Allow home-manager to manage itself
    programs.home-manager.enable = true;
  };
}
