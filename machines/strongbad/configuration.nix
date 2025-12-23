{
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    ./disko.nix
    ./hardware-configuration.nix
    ../../nixos/personalities/base.nix
    ../../nixos/personalities/laptop.nix
    ../../nixos/personalities/workstation.nix
    ../../nixos/personalities/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "strongbad";

  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";

  users.users.bbennett = {
    isNormalUser = true;
    description = "Brandon Bennett";
    shell = pkgs.fish;
    group = "bbennett";
    extraGroups = ["networkmanager" "wheel" "avahi"];
  };
  programs.fish.enable = true;

  users.groups.bbennett = {};

  home-manager.users.bbennett = {
    imports = [
      ../../home
      ./home.nix
    ];
    home.stateVersion = "25.11";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  hardware.graphics.enable = true;

  services.fprintd.enable = true;

  system.stateVersion = "25.11";
}
