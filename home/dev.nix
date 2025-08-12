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
      nur.repos.charmbracelet.crush

      bazel-buildtools
      bazelisk

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

    home.shellAliases = {
      bazel = "bazelisk";
    };
  };
}
