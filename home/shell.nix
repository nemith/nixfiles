{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.shell.enable = lib.mkEnableOption "shell environment";
  };

  config = lib.mkIf config.bbennett.shell.enable {
    home.shell = {
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    home.packages = with pkgs; [
      moreutils
      most
      osc
    ];

    home.shellAliases =
      {
        cd = "z";
        egrep = "egrep --color=auto";
        fgrep = "fgrep --color=auto";
        grep = "grep --color=auto";
        ip = "ip -color";
        ll = "eza -la";
        ls = "eza";
        now = "date +\"%T\"";
        nowdate = "date +\"%d-%m-%Y\"";
        nowtime = "now";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        mosh = "mosh --ssh=/usr/bin/ssh";
      };

    home.sessionVariables = {
      COLORTERM = "truecolor";
      LESS = "--quit-if-one-screen";
      PAGER = "most";
      MANROFFOPT = "-c";
      GIT_FEATURE_BRANCH_PREFIX = "brb/";
    };

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    programs.eza = {
      enable = true;
      colors = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
      ];
    };

    programs.fd = {
      enable = true;
    };

    programs.fish = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
    };

    programs.oh-my-posh = {
      enable = true;

      settings = {
        version = 3;
        final_space = true;
        blocks = [
          {
            type = "prompt";
            alignment = "left";
            segments = [
              # USER
              {
                type = "session";
                foreground = "lightYellow";
                template = " {{ .UserName }}{{ if .SSHSession }}@{{ .HostName }}{{ end }} ";
              }
              # PATH
              {
                type = "path";
                foreground = "lightCyan";
                template = " {{ .Path }} ";
                properties = {
                  style = "agnoster";
                };
              }
              # K8S
              {
                type = "kubectl";
                foreground = "lightCyan";
                template = "󱇶 {{.Context}}{{if .Namespace}}::{{.Namespace}}{{end}} ";
              }
              # GIT
              {
                type = "git";
                foreground = "lightMagenta";
                template = "{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }} ";
                properties = {
                  branch_icon = " ";
                  fetch_status = true;
                };
              }
            ];
          }
          # RIGHT SEGMENT
          {
            type = "prompt";
            alignment = "right";
            segments = [
              # BATTERY
              {
                type = "battery";
                template = "{{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }}% ";
                foreground = "lightGreen";
                foreground_templates = [
                  "{{if lt 10 .Percentage}lightRed{{end}}"
                  "{{if lt 30 .Percentage}lightYellow{{end}}"
                ];
                properties = {
                  charged_icon = "󰁹 ";
                  charging_icon = " ";
                  discharging_icon = "󰂃 ";
                };
              }
              # TIME
              {
                type = "time";
                foreground = "lightYellow";
                template = " {{ .CurrentDate | date .Format }}";
              }
            ];
          }
          {
            type = "prompt";
            alignment = "left";
            newline = true;
            segments = [
              {
                type = "text";
                foreground = "lightWhite";
                template = "❯";
              }
            ];
          }
        ];
        transient_prompt = {
          template = "{{ .Folder }}> ";
        };
      };
    };

    programs.zoxide = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      history = {
        append = true;
        extended = true;
      };
      shellAliases = {
        path = "echo -e \${PATH//:/\\n}";
      };

      historySubstringSearch.enable = true;
      initContent = builtins.readFile ./configs/extra.zshrc;
    };
  };
}
