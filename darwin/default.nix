{
  inputs,
  pkgs,
  config,
  ...
}: {
  # Let determinate nix manage nix
  nix.enable = false;

  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    ./system.nix
    ./homebrew.nix
  ];

  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
  };

  programs.fish.enable = true;
  #TODO: remove from default config for user specific settings
  users.users.bbennett.shell = pkgs.fish;
}
