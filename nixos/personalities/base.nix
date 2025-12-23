{pkgs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  system.autoUpgrade.enable = false; # Use flakes manually instead
  nixpkgs.config.allowUnfree = true;

  services.fwupd.enable = true;
  services.thermald.enable = true;
  hardware.enableAllFirmware = true;

  services.fstrim.enable = true;
  boot.tmp.useTmpfs = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];
}
