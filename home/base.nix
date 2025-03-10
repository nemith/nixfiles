{
  config,
  pkgs,
  ...
}:

{
  home.shell.enableZshIntegration = true;
  home.shell.enableFishIntegration = true;

  home.shellAliases = {
    cd = "z";
    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";
    grep = "grep --color=auto";
    ip = "ip -color";
    ll = "eza -la";
    ls = "eza";
    vi = "nvim";
    now = "date +\"%T\"";
    nowtime = "now";
    nowdate = "date +\"%d-%m-%Y\"";
  };

  home.sessionVariables = {
    COLORTERM = "truecolor";
    LESS = "--quit-if-one-screen";
    PAGER = "most";
    MANROFFOPT = "-c";
  };

  home.packages = with pkgs; [
    ansible-lint
    ast-grep
    bottom
    buf
    coreutils
    curl
    curlie
    delta
    duf
    fastfetch
    file
    gnumake
    gnutar
    graphviz
    gron
    grpcui
    grpcurl
    htop
    inetutils
    iperf
    just
    lazydocker
    moreutils
    mosh
    most
    mtr
    ncdu
    nh
    nixfmt-rfc-style
    nvd
    nmap
    procs
    protobuf
    scc
    sleek
    socat
    sqlite
    tree
    trurl
    unzip
    watch
    wcurl
    wget
    xan # active fork of xsv
    xz
    yt-dlp
    zstd

    postgresql_16
    ansible

    atlas
    awscli
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

    elixir
    gleam
    nodePackages.prettier
    nodejs_23
    python313
    rustup
    uv

    lldb

    gopls
    gofumpt
    golangci-lint
    golangci-lint-langserver
    delve

    nil # language server for nix

    zig
    zls

    # fonts
    dosis
    fira-go
    nerd-fonts.blex-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    vista-fonts #consolas
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

  programs.earthly = {
    enable = true;
    settings = {
      global = {
        disable_analytics = true;
        disable_log_sharing = true;
      };
    };
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

    userEmail = "brandon@brbe.me";
    userName = "Brandon Bennett";

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
      init = {
        defaultBranch = "main";
      };
      rebase = {
        updateRefs = true;
      };
      log = {
        abbrevCommit = true;
      };
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
    package = pkgs.go_1_24;
    goPath = ".local/go";
    telemetry.mode = "off";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "adwaita-dark";

      editor.end-of-line-diagnostics = "hint";
      editor.inline-diagnostics.cursor-line = "warning";
    };

    languages = {
      language-server.gopls.config = {
        gofumpt = true;
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
      email = "brandon@brbe.me";
      name = "Brandon Bennett";
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

  programs.starship = {
    enable = true;
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      auto_update = true;
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      pane_frames = false;
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
      e = "\${EDITOR:-nvim}";
      path = "echo -e \${PATH//:/\\n}";
    };
    historySubstringSearch.enable = true;
  };

  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
