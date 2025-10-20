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
      delta
      git
    ];

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit (cfg.user) email;
          inherit (cfg.user) name;
        };
        ui = {
          pager = ["delta" "--pager" "less -FRX"];
          paginate = "auto";
          diff-formatter = ":git"; # Needed for delta
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
          tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];

          clone = ["git" "clone" "--colocate"];
          push = ["git" "push"];
          fetch = ["git" "fetch"];

          up = ["edit" "@-"];
          down = ["edit" "@+"];
        };
        templates = {
          git_push_bookmark = ''"brb/push-" ++ change_id.short()'';
        };
      };
    };
  };
}
