{...}: {
  bbennett.work = {
    enable = true;
    flavor = "laptop";
    vdiHostname = "bbennett-1.tenant-coreweave-vdi.coreweave.cloud";
  };

  bbennett.jujutsu = {
    enable = true;
    user = {
      email = "bbennett@coreweave.com";
      name = "Brandon Bennett";
    };
  };

  bbennett.lemonade = {
    enable = true;
    server = {
      enable = true;
    };
  };
}
