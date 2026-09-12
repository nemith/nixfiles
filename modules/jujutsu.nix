{ inputs, ... }: {
  # jj-gh publishes a Cachix binary cache; opt in so `jj pr` deps don't build locally.
  flake.modules.darwin.base = _: {
    nix.settings = {
      extra-substituters = [ "https://jj-gh.cachix.org" ];
      extra-trusted-public-keys = [ "jj-gh.cachix.org-1:N1uFBMDd9znlhDa68BRqLSXYzXXJ2+WHVuwxpGxCtDo=" ];
    };
  };

  flake.modules.homeManager.jujutsu = { lib, pkgs, ... }: {
    imports = [ inputs.jj-gh.homeManagerModules.default ];

    programs.delta = {
      enable = true;
      enableJujutsuIntegration = true;
    };

    programs.jujutsu = {
      enable = true;

      # jj-gh: GitHub PR integration, exposed as `jj pr` (see mrjones2014/jj-gh).
      gh = {
        enable = true;
        settings = {
          default_base_branch = "main";
          default_remote = "origin";
        };
      };

      settings = {
        user = {
          name = lib.mkDefault "Brandon Bennett";
          email = lib.mkDefault "brandon@brbe.me";
        };

        ui = {
          paginate = "auto";
          # Keep paged output visible after quitting delta's pager.
          pager = lib.mkForce [
            "${pkgs.delta}/bin/delta"
            "--pager"
            "${pkgs.less}/bin/less -FRX"
          ];
          default-command = [
            "pr"
            "log"
          ];
        };

        # difftastic as an opt-in diff tool: `jj diff --tool difft`.
        # delta stays the default (ui.diff untouched).
        merge-tools.difft = {
          program = "${pkgs.difftastic}/bin/difft";
          diff-args = [
            "--color=always"
            "$left"
            "$right"
          ];
        };

        git = {
          colocate = true;
          write-change-id-header = true;
        };

        aliases = {
          d = [ "diff" ];
          # Structural (AST-aware) diff via difftastic (merge-tools.difft above).
          difft = [
            "diff"
            "--tool"
            "difft"
          ];
          dt = [
            "diff"
            "--tool"
            "difft"
          ];
          n = [ "new" ];
          nt = [
            "new"
            "trunk()"
          ];
          s = [ "status" ];
          sq = [ "squash" ];
          amend = [ "squash" ];

          hide = [ "abandon" ];
          blame = [
            "file"
            "annotate"
          ];
          cat = [
            "file"
            "show"
          ];
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

          clone = [
            "git"
            "clone"
            "--colocate"
          ];
          fetch = [
            "git"
            "fetch"
          ];
          push = [
            "util"
            "exec"
            "--"
            "uvx"
            "--with"
            "pre-commit"
            "jj-pre-push"
            "push"
          ];
          check = [
            "util"
            "exec"
            "--"
            "uvx"
            "--with"
            "pre-commit"
            "jj-pre-push"
            "check"
          ];
          submit = [
            "util"
            "exec"
            "--"
            "bash"
            "-c"
            ''
              set -euo pipefail
              # Stack = non-empty, described commits between trunk and the target (defaults to @).
              target="''${1:-@}"
              revset="trunk()..$target & ~empty() & ~description(exact:\"\")"

              # Resolve the stack oldest-first before creating PRs.
              mapfile -t revisions < <(jj log -r "$revset" --reversed --no-graph \
                -T 'commit_id ++ "\n"')
              if [ "''${#revisions[@]}" -eq 0 ]; then
                echo "no revisions to submit in: $revset" >&2
                exit 1
              fi

              # Auto-create push bookmarks (git_push_bookmark template) and update existing ones.
              # jj-gh's create command skips the push when it finds an existing PR.
              jj git push -c "$revset"

              # Let jj-gh create or reuse each PR. Stack linking is done explicitly below.
              jj pr create --draft --no-edit --no-stack \
                -T 'description.remove_prefix(description.first_line()).trim_start()' \
                "''${revisions[@]}"

              # A single PR is not a stack. For multiple PRs, make GitHub match the local graph.
              if [ "''${#revisions[@]}" -gt 1 ]; then
                jj pr stack "''${revisions[@]}"
              fi

              # jj-gh's edit flow is interactive, so keep gh for non-interactive metadata updates.
              mapfile -t bookmarks < <(jj log -r "$revset" --reversed --no-graph \
                -T 'local_bookmarks.map(|b| b.name()).join("\n") ++ "\n"' | grep -v '^$')
              for b in "''${bookmarks[@]}"; do
                desc=$(jj log -r "$b" --no-graph -T description)
                title=$(printf '%s\n' "$desc" | head -n1)
                body=$(printf '%s\n' "$desc" | tail -n +2 | sed '/./,$!d')
                if [ -n "$body" ]; then
                  gh pr edit "$b" --title "$title" --body "$body"
                else
                  gh pr edit "$b" --title "$title"
                fi
              done
            ''
            "submit"
          ];

          up = [
            "edit"
            "@-"
          ];
          down = [
            "edit"
            "@+"
          ];
        };

        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_pushable(to)" =
            ''heads(::to & mutable() & ~description(exact:"") & (~empty() | merges()))'';
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
