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

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.git = {
      enable = true;

      settings = {
        user.email = lib.mkDefault "brandon@brbe.me";
        user.name = lib.mkDefault "Brandon Bennett";
        init.defaultBranch = "main";
        rebase.updateRefs = true;
        log.abbrevCommit = true;
        alias = {
          amend = "commit --amend --no-edit -a";
          addremove = "!git add . && git add -u";
          s = "status";
          co = "checkout";
        };
        url."git@github.com:".insteadOf = "https://github.com/";
      };

      maintenance.enable = true;
    };

    programs.lazygit = {
      enable = true;
    };
  };
}
