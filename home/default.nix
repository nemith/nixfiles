{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  home.stateVersion = "24.11";

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./dev.nix
    ./k8s.nix
    ./litra.nix
    ./neovim.nix
    ./work.nix
  ];

  bbennett.dev.enable = lib.mkDefault true;
  bbennett.k8s.enable = lib.mkdefault config.bbennett.dev.enable;
  bbennett.litra.enable = lib.mkDefault lib.mkIf pkgs.stdenv.isDarwin;
  bbennett.neovim.enable = lib.mkDefault true;

  home.shell.enableZshIntegration = true;
  home.shell.enableFishIntegration = true;

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
    "$HOME/.local/go/bin"
  ];

  catppuccin.enable = true;

  home.packages = with pkgs; [
    bandwhich
    bottom
    curl
    curlie
    cyme
    delta
    duf
    dust
    fastfetch
    fend
    file
    glances
    gnutar
    graphviz
    gron
    htop
    hyperfine
    iperf
    mitmproxy
    moreutils
    mosh
    most
    mtr
    ncdu
    nixfmt-rfc-style
    nix-search-cli
    nmap
    osc
    picocom
    procs
    psutils
    sd
    socat
    sqlite
    sshpass
    tcpdump
    tree
    trurl
    unar
    unrar-wrapper
    unzip
    uutils-coreutils-noprefix
    viddy
    watch
    wget
    xan # active fork of xsv
    xh # clone of httpie
    xz
    yq
    yt-dlp
    zstd

    # atlas
    terraform
    opentofu

    # fonts
    dosis
    fira-go
    nerd-fonts.blex-mono
    nerd-fonts.fira-code
    nerd-fonts.im-writing
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.space-mono
    nerd-fonts.terminess-ttf
    vista-fonts # consolas
  ];

  programs.bat = {
    enable = true;
  };

  programs.broot = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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

  programs.go = {
    enable = true;
    goPath = ".local/go";
    telemetry.mode = "off";
  };

  programs.helix = {
    enable = true;

    settings = {
      editor = {
        clipboard-provider = "termcode";
        popup-border = "all";
        cursorline = true;
        end-of-line-diagnostics = "hint";
        color-modes = true;
        inline-diagnostics = {
          cursor-line = "warning";
        };
      };
    };
  };

  programs.jq = {
    enable = true;
  };

  programs.jqp = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = lib.mkDefault "brandon@brbe.me";
        name = lib.mkDefault "Brandon Bennett";
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
        s = ["status"];
        d = ["diff"];
        n = ["new" "trunk()"];

        hide = ["abandon"];
        blame = ["file" "annotate"];
        cat = ["file" "show"];

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

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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

  programs.ripgrep = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = lib.concatStringsSep "\n" (
      lib.optional pkgs.stdenv.isDarwin "UseKeychain yes"
    );
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      ui.pane_frames = {
        rounded_corners = true;
      };
      pane_viewport_serialization = "true";
      default_shell = "zsh";
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

  services = {
    home-manager.autoExpire.enable = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
