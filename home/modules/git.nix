{
  lib,
  config,
  ...
}: {
  options = {
    bbennett.git.enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf config.bbennett.git.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    programs.gh-dash = {
      enable = true;
    };

    programs.git = {
      enable = true;

      userEmail = lib.mkDefault "brandon@brbe.me";
      userName = lib.mkDefault "Brandon Bennett";

      maintenance.enable = true;

      delta.enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        rebase.updateRefs = true;
        log.abbrevCommit = true;
        url."git@github.com:".insteadOf = "https://github.com/";
      };

      aliases = {
        amend = "commit --amend --no-edit -a";
        addremove = "!git add . && git add -u";
        s = "status";
        co = "checkout";
      };
    };

    programs.lazygit = {
      enable = true;
    };
  };
}
