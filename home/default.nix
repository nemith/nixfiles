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
    ./ghostty.nix
    ./git.nix
    ./go.nix
    ./jujutsu.nix
    ./k8s.nix
    ./lemonade.nix
    ./litra.nix
    ./neovim.nix
    ./python.nix
    ./shell.nix
    ./ssh.nix
    ./vscode.nix
    ./zellij.nix
  ];

  bbennett.neovim.enable = lib.mkDefault true;
  bbennett.shell.enable = lib.mkDefault true;
  bbennett.ssh.enable = lib.mkDefault true;
  bbennett.zellij.enable = lib.mkDefault true;

  bbennett.dev.enable = lib.mkDefault true;
  bbennett.k8s.enable = lib.mkDefault config.bbennett.dev.enable;
  bbennett.jujutsu.enable = lib.mkDefault config.bbennett.dev.enable;
  bbennett.git.enable = lib.mkDefault config.bbennett.dev.enable;
  bbennett.go.enable = lib.mkDefault config.bbennett.dev.enable;
  bbennett.python.enable = lib.mkDefault config.bbennett.dev.enable;

  bbennett.litra.enable = lib.mkIf pkgs.stdenv.isDarwin (lib.mkDefault true);
  bbennett.ghostty.enable = lib.mkIf pkgs.stdenv.isDarwin (lib.mkDefault true);
  bbennett.vscode.enable = lib.mkIf pkgs.stdenv.isDarwin (lib.mkDefault true);

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
    mtr
    ncdu
    nix-search-cli
    nixfmt-rfc-style
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

    # fonts
    dosis
    fira-go
    maple-mono.NF
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

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  services = {
    home-manager.autoExpire.enable = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
