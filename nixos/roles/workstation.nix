{
  config,
  lib,
  pkgs,
  ...
}: {
  options.bbennett.roles.workstation.enable = lib.mkEnableOption "Enable workstation personality";

  config = lib.mkIf config.bbennett.roles.workstation.enable {
    boot = {
      consoleLogLevel = 3;
      initrd = {
        verbose = false;
        systemd.enable = true;
      };
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      loader.timeout = 0;

      plymouth = {
        enable = true;
      };
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    programs.dconf.profiles.user = {
      databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              clock-format = "24h";
              clock-show-weekday = true;
            };
            "org/gnome/mutter" = {
              experimental-features = [
                "scale-monitor-framebuffer"
              ];
            };
          };
        }
      ];
    };
    programs.xwayland.enable = true;
    services.gnome.gcr-ssh-agent.enable = true;
    environment.systemPackages = with pkgs; [
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.paperwm
      gnomeExtensions.system-monitor

      vicinae
      gnomeExtensions.vicinae

      gnome-tweaks
      cheese

      gsettings-desktop-schemas

      x265
      lm_sensors
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
    ];

    services.gnome.rygel.enable = true;

    services.system76-scheduler.enable = true;

    networking.networkmanager.enable = true;

    services.avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        hinfo = true;
        addresses = true;
        workstation = true;
      };
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    services.pipewire.enable = true;
    services.udisks2.enable = true;
    services.printing.enable = true;
  };
}
