{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.dev.enable = lib.mkEnableOption "dev environment";
  };

  config = lib.mkIf config.bbennett.dev.enable {
    home.packages = with pkgs; [
      ast-grep
      delta
      gnumake
      grex
      grpcui
      grpcurl
      hexyl
      just
      lazydocker
      miniserve
      sleek

      ansible
      ansible-lint

      postgresql_16

      scc
      tokei

      protobuf
      buf

      opencode
      claude-code

      bazel-buildtools
      bazelisk

      # python
      python313
      pre-commit
      uv
      poetry

      # go
      gofumpt
      golangci-lint
      delve
      gotools

      zig

      nodePackages.prettier
      nodejs # LTS

      elixir
      gleam
      rustup
      lldb
    ];

    programs.lazygit = {
      enable = true;
    };

    programs.ruff = {
      enable = true;
      settings = {};
    };

    home.shellAliases = {
      bazel = "bazelisk";
    };
  };
}
