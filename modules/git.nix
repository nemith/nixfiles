_: {
  flake.modules.homeManager.git = { lib, pkgs, ... }: {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      extensions = [ pkgs.gh-stack ];
      settings.git_protocol = "ssh";
    };

    programs.gh-dash = {
      enable = true;
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    # difftastic: structural (AST-aware) diff. Opt-in only; delta stays the
    # default pager. Used via the difft/logt/showt aliases below.
    home.packages = [ pkgs.difftastic ];

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
          # Structural diffs via difftastic; plain `git diff` still uses delta.
          difft = "-c diff.external=difft diff";
          logt = "-c diff.external=difft log -p --ext-diff";
          showt = "-c diff.external=difft show --ext-diff";
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
