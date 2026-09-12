{ self, inputs, ... }: {
  # catppuccin/nix publishes a Cachix binary cache; opt in so themed packages
  # don't rebuild locally.
  flake.modules.darwin.base = _: {
    nix.settings = {
      extra-substituters = [ "https://catppuccin.cachix.org" ];
      extra-trusted-public-keys = [
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      ];
    };
  };

  flake.modules.homeManager.shell = { pkgs, lib, ... }: {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
      self.modules.homeManager.zsh
      self.modules.homeManager.starship
      self.modules.homeManager.neovim
      self.modules.homeManager.ssh
      self.modules.homeManager.zellij
    ];

    catppuccin = {
      enable = true;
      autoEnable = true;
    };

    home.packages =
      with pkgs;
      [
        moreutils
        most
        osc
        bandwhich
        bottom
        curl
        curlie
        cyme
        doggo # DNS client
        duf
        dust
        fastfetch
        fend
        file
        fx # interactive JSON viewer
        glances
        gnutar
        gping # ping with a graph
        graphviz
        gron
        htop
        hyperfine
        iperf
        mitmproxy
        mosh
        mtr
        ncdu
        nix-search-cli
        nixfmt
        nmap
        picocom
        procs
        psutils
        pv
        sd
        socat
        sqlite
        tcpdump
        tree
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
      ++ lib.optionals stdenv.hostPlatform.isLinux [ xclip ];

    home.shellAliases = {
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
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin { mosh = "mosh --ssh=/usr/bin/ssh"; };

    home.sessionVariables = {
      COLORTERM = "truecolor";
      LESS = "--quit-if-one-screen";
      PAGER = "most";
      MANROFFOPT = "-c";
    };

    home.sessionPath = [ "$HOME/.local/bin" ];

    programs.eza = {
      enable = true;
      colors = "auto";
      git = true;
      extraOptions = [ "--group-directories-first" ];
    };

    programs.fd = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
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
    };

    programs.ripgrep = {
      enable = true;
    };

    programs.yazi = {
      enable = true;
      # Upstream's new default; set explicitly since home.stateVersion < 26.05
      # still pins the legacy "yy" wrapper.
      shellWrapperName = "y";
    };
  };
}
