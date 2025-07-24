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

  bbennett.lemonade = {
    enable = true;
    pbAliases = true;
    browserEnv = true;
  };
}
