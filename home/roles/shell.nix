{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.roles.shell.enable = lib.mkEnableOption "shell environment" // {default = true;};
  };

  config = lib.mkIf config.bbennett.roles.shell.enable {
    bbennett.programs = {
      fish.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };

    home.packages = with pkgs;
      [
        moreutils
        most
        osc
        bandwhich
        bottom
        curl
        curlie
        cyme
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
        mtr
        ncdu
        nix-search-cli
        nixfmt
        nmap
        picocom
        procs
        psutils
        sd
        socat
        sqlite
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
        yq-go
        yt-dlp
        zstd
      ]
      ++ lib.optionals stdenv.isLinux [
        xclip
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

    programs.fzf = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
    };
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

    programs.ripgrep = {
      enable = true;
    };
  };
}
