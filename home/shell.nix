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
              # OS
              {
                type = "os";
                foreground = "lightGreen";
                template = "{{ if .WSL }}[WSL]{{ end }}{{.Icon}} ";
              }
              # USER
              {
                type = "session";
                foreground = "lightYellow";
                foreground_templates = [
                  ''
                    {{- $colors := list "f38ba8" "ff6b35" "fab387" "d4af37" "f9e2af" "a6e3a1" "40a02b" "20b2aa"
                                        "94e2d5" "6bcae2" "89b4fa" "4682b4" "1e66f5" "8839ef" "9370db" "cba6f7"
                                        "f5c2e7" "ff8fab" "dc8a78" "8b4513" "696969" "a9a9a9" "c0c0c0" "2f3349"
                                        "b8860b" "87ceeb" "32cd32" "ff1493" "8fbc8f" "dda0dd" "f0e68c" "cd853f" -}}
                    {{- $hostnameHash := mod (printf "0x%s" ( .HostName | sha1sum | trunc 8) | int ) (len $colors) -}}
                    {{ printf "#%s" (index $colors $hostnameHash) -}}
                  ''
                ];
                template = "{{ if .SSHSession }} {{ else }} {{end }}{{ .UserName }}{{ if .SSHSession }}@{{ .HostName }}{{ end }} ";
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
                foreground = "lightYellow";
                template = "󱇶 {{.Context}}{{if .Namespace}}::{{.Namespace}}{{end}} ";
              }
              # JUJUTSU
              {
                type = "jujutsu";
                foreground = "lightMagenta";
                template = " {{.ChangeID}}{{if .Working.Changed}}  {{ .Working.String }}{{ end }} ";
                properties = {
                  fetch_status = true;
                  #log_templates = {
                  #  change_id_prefix =  "change_id.shortest(8).prefix()";
                  #  change_id_rest =  "change_id.shortest(8).rest()";
                  #};
                };
              }
              # GIT
              {
                type = "git";
                foreground = "lightMagenta";
                template = "{{ if not (.Segments.Contains \"Jujutsu\") }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }} {{ end }}";
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
