{inputs, ...}: {
  targets.genericLinux.enable = true;

  home = {
    username = "bbennett";
    homeDirectory = "/home/bbennett";
  };

  bbennett.work = {
    enable = true;
    flavor = "vdi";
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
    pbAliases = true;
    browserEnv = true;
  };
}
