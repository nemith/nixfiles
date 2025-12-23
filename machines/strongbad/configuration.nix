{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    ./disko.nix
    ./hardware-configuration.nix
  ];

  bbennett.roles = {
    base.enable = true;
    laptop.enable = true;
    workstation.enable = true;
    gaming.enable = true;
    devel.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "strongbad";

  hardware.enableAllFirmware = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";

  users.users.bbennett = {
    isNormalUser = true;
    description = "Brandon Bennett";
    shell = pkgs.fish;
    group = "bbennett";
    extraGroups = [
      "networkmanager"
      "wheel"
      "avahi"
      "video"
    ];
  };
  programs.fish.enable = true;

  users.groups.bbennett = {};

  home-manager.users.bbennett = {
    imports = [
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
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.fprintd.enable = true;
  services.udev.packages = [pkgs.litra-autotoggle];

  system.stateVersion = "25.11";
}
