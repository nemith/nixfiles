{ inputs, pkgs, config, ... }:
{
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
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
  };

  programs.fish.enable = true;
  #TODO: remove from default config for user specific settings1
  users.users.bbennett.shell = pkgs.fish;

  nix = {
    package = pkgs.lix;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
    '';
    settings = {
      #TODO: remove from default config for user specific settings1
      trusted-users = [ "bbennett" ];
    };
  };
}
