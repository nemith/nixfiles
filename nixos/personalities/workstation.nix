{pkgs, ...}: {
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
  programs.xwayland.enable = true;
  services.gnome.gcr-ssh-agent.enable = true;
  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.paperwm
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
}
