{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bbennett.jujutsu;
in {
  options.bbennett.jujutsu = {
    enable = lib.mkEnableOption "jujutsu";

    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Brandon Bennett";
        description = "Name for Jujutsu user";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = "brandon@brbe.me";
        description = "Email for Jujutsu user";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      uv # needed for uvx
      gh
    ];

    programs.delta = {
      enable = true;
      enableJujutsuIntegration = true;
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit (cfg.user) email;
          inherit (cfg.user) name;
        };

        ui = {
          paginate = "auto";
        };

        git = {
          colocate = true;
          write-change-id-header = true;
        };

        aliases = {
          d = ["diff"];
          n = ["new"];
          nt = ["new" "trunk()"];
          s = ["status"];
          sq = ["squash"];
          amend = ["squash"];

          hide = ["abandon"];
          blame = ["file" "annotate"];
          cat = ["file" "show"];
          #tug = ["bookmark" "move" "--from" "heads(::@ & bookmarks())" "--to" "closest_pushable(@)"];
          tug = [
            "util"
            "exec"
            "--"
            "sh"
            "-c"
            ''
              if [ "x$1" = "x" ]; then
                jj bookmark move --from "closest_bookmark(@)" --to "closest_pushable(@)"
              else
                jj bookmark move --to "closest_pushable(@)" "$@"
              fi
            ''
          ];

          clone = ["git" "clone" "--colocate"];
          fetch = ["git" "fetch"];
          push = ["util" "exec" "--" "uvx" "--with" "pre-commit" "jj-pre-push" "push"];
          check = ["util" "exec" "--" "uvx" "--with" "pre-commit" "jj-pre-push" "check"];
          pr = [
            "util"
            "exec"
            "--"
            "bash"
            "-c"
            ''
              gh pr create --head $(jj log -r 'closest_bookmark(@)' -T 'bookmarks' --no-graph | cut -d ' ' -f 1)
            ''
          ];

          up = ["edit" "@-"];
          down = ["edit" "@+"];
        };

        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_pushable(to)" = ''heads(::to & mutable() & ~description(exact:"") & (~empty() | merges()))'';
        };

        templates = {
          git_push_bookmark = ''"brb/push-" ++ change_id.short()'';
          draft_commit_description = ''
            concat(
              coalesce(description, default_commit_description, "\n"),
              surround(
                "\nJJ: This commit contains the following changes:\n", "",
                indent("JJ:     ", diff.stat(72)),
              ),
              "\nJJ: ignore-rest\n",
              diff.git(),
            )
          '';
          log_node = ''
            if(self && !current_working_copy && !immutable && !conflict && in_branch(self),
              "◇",
              builtin_log_node
            )
          '';
        };
        template-aliases = {
          "in_branch(commit)" = ''commit.contained_in("immutable_heads()..bookmarks()")'';
        };
      };
    };
  };
}
