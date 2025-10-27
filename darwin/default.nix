{
  inputs,
  pkgs,
  ...
}: {
  nix = {
    gc.automatic = true;
    optimise.automatic = true;

    linux-builder.enable = true;

    settings = {
      trusted-users = ["@admin"];
      "extra-experimental-features" = ["nix-command" "flakes"];
    };
  };

  imports = [
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
  };

  programs.fish.enable = true;
  #TODO: remove from default config for user specific settings
  users.users.bbennett.shell = pkgs.fish;
}
