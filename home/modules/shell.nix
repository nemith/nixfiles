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
    programs.bash = {
       initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

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
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];
    };

    programs.fzf = {
      enable = true;
    };

    programs.starship = {
      enable = true;
      settings = let
        mkGitModule = name: moduleConfig: {
          "${name}" =
            {
              disabled = true;
            }
            // moduleConfig;

          custom."${name}" = {
            when = "! jj --ignore-working-copy root";
            command = "starship module ${name}";
            style = "";
          };
        };
      in
        lib.mkMerge [
          {
            format = lib.concatStrings [
              # Left
              "$username"
              "$hostname"
              "$directory"
              "$\{custom.git_branch\}"
              "$\{custom.git_commit\}"
              "$\{custom.git_state\}"
              "$\{custom.git_metrics\}"
              "$\{custom.git_status\}"
              "$\{custom.jj\}"

              "$fill"

              # Right
              "$docker_context"
              "$kubernetes"
              "$memory_usage"
              "$battery"
              "$os"
              "\n"
              "$character"
            ];
            os = {
              disabled = false;
              style = "bold green";
              symbols = {
                Alpaquita = " ";
                Alpine = " ";
                AlmaLinux = " ";
                Amazon = " ";
                Android = " ";
                Arch = " ";
                Artix = " ";
                CachyOS = " ";
                CentOS = " ";
                Debian = " ";
                DragonFly = " ";
                Emscripten = " ";
                EndeavourOS = " ";
                Fedora = " ";
                FreeBSD = " ";
                Garuda = "󰛓 ";
                Gentoo = " ";
                HardenedBSD = "󰞌 ";
                Illumos = "󰈸 ";
                Kali = " ";
                Linux = " ";
                Mabox = " ";
                Macos = " ";
                Manjaro = " ";
                Mariner = " ";
                MidnightBSD = " ";
                Mint = " ";
                NetBSD = " ";
                NixOS = " ";
                Nobara = " ";
                OpenBSD = "󰈺 ";
                openSUSE = " ";
                OracleLinux = "󰌷 ";
                Pop = " ";
                Raspbian = " ";
                Redhat = " ";
                RedHatEnterprise = " ";
                RockyLinux = " ";
                Redox = "󰀘 ";
                Solus = "󰠳 ";
                SUSE = " ";
                Ubuntu = " ";
                Unknown = " ";
                Void = " ";
                Windows = "󰍲 ";
              };
            };

            fill = {
              symbol = " ";
            };

            username = {
              format = "[ $user]($style) ";
              style_user = "bold green";
              disabled = false;
            };

            hostname = {
              ssh_symbol = " ";
            };

            directory = {
              format = "[ $path]($style)[$read_only]($read_only_style) ";
              read_only = " 󰌾";
            };

            # Re-enable once a new version of starship ships with https://github.com/starship/starship/pull/6861
            custom.jj = {
              command = "prompt";
              format = "$output";
              ignore_timeout = true;
              shell = ["${pkgs.starship-jj}/bin/starship-jj" "--ignore-working-copy" "starship"];
              use_stdin = false;
              when = true;
            };

            docker_context = {
              symbol = " ";
            };

            kubernetes = {
              disabled = false;
              format = "[$symbol$context( \($namespace\))]($style) ";
              symbol = "󱇶 ";
              style = "bold yellow";
            };

            hg_branch = {
              symbol = " ";
            };

            battery = {
              disabled = false;
            };
          }
          (mkGitModule "git_branch" {
            format = "[$symbol$branch(:$remote_branch)]($style) ";
            symbol = " ";
          })
          (mkGitModule "git_commit" {
            tag_symbol = "  ";
          })
          (mkGitModule "git_state" {})
          (mkGitModule "git_metrics" {})
          (mkGitModule "git_status" {})
        ];
    };

    home.file.".config/starship-jj/starship-jj.toml".source = (pkgs.formats.toml {}).generate "starship-jj.toml" {
      module = [
        {
          type = "Symbol";
          symbol = " ";
          color = "Magenta";
        }
        #{
        #  type = "Commit";
        #  max_length = 24;
        #  empty_text = "(no description set)";
        #  surround_with_quotes = true;
        #}
        {
          type = "Bookmarks";
          separator = " ";
          color = "Magenta";
          behind_symbol = "⇡";
          surround_with_quotes = false;
        }
        {
          type = "State";
          separator = " ";
          conflict = {
            disabled = false;
            text = "󰰲 ";
            color = "Red";
          };
          divergent = {
            disabled = false;
            text = "󰵌 ";
            color = "Cyan";
          };
          empty = {
            disabled = false;
            text = "󰟼 ";
            color = "Yellow";
          };
          immutable = {
            disabled = false;
            text = "󰍁 ";
            color = "Yellow";
          };
          hidden = {
            disabled = false;
            text = "󰊠 ";
            color = "Yellow";
          };
        }
        {
          type = "Metrics";
          template = " {changed} {added} {removed}";
          color = "Magenta";
          changed_files = {
            prefix = "~";
            suffix = "";
            color = "Yellow";
          };
          added_lines = {
            prefix = "+";
            suffix = "";
            color = "Green";
          };
          removed_lines = {
            prefix = "-";
            suffix = "";
            color = "Red";
          };
        }
      ];
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
      initContent = builtins.readFile ./../configs/extra.zshrc;
    };
  };
}
