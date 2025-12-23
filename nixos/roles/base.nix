{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bbennett.roles.base.enable = lib.mkEnableOption "Enable base personality";

  config = lib.mkIf config.bbennett.roles.base.enable {
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

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
    ];

    environment.systemPackages = with pkgs; [
      neovim
      git
      curl

      iproute2
      tcpdump
      traceroute
      mtr
      iperf3

      # Hardare information
      dmidecode
      lshw
      util-linux # lscpu, lsblk etc
      inxi
      hwinfo

      htop
      btop
      duf

      fd
      findutils
      ripgrep
      tree
      gnugrep

      zip
      unzip
      gnutar
      gzip
      bzip2
      xz
      p7zip

      gnused
      jq

      gnumake
      gcc
      strace
    ];
  };
}
