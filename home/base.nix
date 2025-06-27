{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  home.shell.enableZshIntegration = true;
  home.shell.enableFishIntegration = true;

  home.shellAliases = {
    bazel = "bazelisk";
    cd = "z";
    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";
    grep = "grep --color=auto";
    ip = "ip -color";
    k = "kubectl";
    kctx = "kubectx";
    kns = "kubens";
    ktx = "kubectx";
    ll = "eza -la";
    ls = "eza";
    now = "date +\"%T\"";
    nowdate = "date +\"%d-%m-%Y\"";
    nowtime = "now";
    vi = "nvim";
  };

  home.sessionVariables = {
    COLORTERM = "truecolor";
    LESS = "--quit-if-one-screen";
    PAGER = "most";
    MANROFFOPT = "-c";
    GIT_FEATURE_BRANCH_PREFIX="brb/";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/go/bin"
  ];

  #home.file.".config/ghostty/config".source = ./configs/ghostty-config;


  home.packages = with pkgs; [
    ansible-lint
    ast-grep
    bandwhich
    bottom
    btop
    buf
    claude-code
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
    gnumake
    gnutar
    graphviz
    grex
    gron
    grpcui
    grpcurl
    hexyl
    htop
    # hurl # 6/26/25  This is broken to build for some reason
    hyperfine
    inetutils
    iperf
    just
    lazydocker
    miniserve
    mitmproxy
    moreutils
    mosh
    most
    mtr
    ncdu
    nh
    nixfmt-rfc-style
    nmap
    nvd
    picocom
    pre-commit
    procs
    protobuf
    psutils
    scc
    sd
    sleek
    socat
    sqlite
    tcpdump
    tokei
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

    postgresql_16
    ansible

    # atlas
    awscli2
    aws-vault
    bazel-buildtools
    bazelisk
    buildkite-cli
    ent-go
    google-cloud-sdk
    kubernetes-helm
    kubectl
    kubectx
    kubeswitch
    kustomize
    terraform
    opentofu

    elixir
    gleam
    nodePackages.prettier
    nodejs # LTS
    rustup
    lldb

    # python
    python313

    uv
    poetry

    # go
    gopls
    gofumpt
    golangci-lint
    #golangci-lint-langserver
    delve

    nil # language server for nix

    zig
    zls

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

  home.file.".local/bin/git-feature" = {
    source = ./scripts/git-feature.sh;
    executable = true;
  };

  home.file.".local/bin/git-wtclone" = {
    source = ./scripts/git-wtclone.sh;
    executable = true;
  };

  programs.git = {
    enable = true;

    userEmail = lib.mkDefault "brandon@brbe.me";
    userName = lib.mkDefault "Brandon Bennett";

    maintenance.enable = true;

    delta = {
      enable = true;
      options = {
        file-style- = "bright-yellow";
        hunk-header-style = "bold syntax";
        minus-style = "bold red";
        minus-non-emph-style = "bold red";
        minus-emph-style = "bold red 52";
        zero-style = "normal";
        plus-style = "bold green";
        plus-non-emph-style = "bold green";
        plus-emph-style = "bold green 22";
        line-numbers = true;
      };
    };

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

  programs.jq = {
    enable = true;
  };

  programs.jqp = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      email = lib.mkDefault "brandon@brbe.me";
      name = lib.mkDefault "Brandon Bennett";
      ui = {
        paginate = "auto";
      };
    };
  };

  programs.k9s = {
    enable = true;
  };

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      lua-language-server
      stylua
      ripgrep
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
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
                style = "powerlevel";
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

  programs.ruff = {
    enable = true;
    settings = { };
  };

  programs.ssh = {
    enable = true;
  };

  #  programs.starship = {
  #    enable = true;
  #    settings = {
  #      kubernetes.disabled = false;
  #    };
  #  };

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
      pane_frames = false;
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
  };

  services = {
    home-manager.autoExpire.enable = true;
  };

  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
