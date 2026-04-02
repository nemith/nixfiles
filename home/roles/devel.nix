{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.roles.devel.enable = lib.mkEnableOption "development personality";
  };

  config = lib.mkIf config.bbennett.roles.devel.enable {
    bbennett.programs.git.enable = lib.mkDefault true;
    bbennett.programs.go.enable = lib.mkDefault true;
    bbennett.programs.jujutsu.enable = lib.mkDefault true;
    bbennett.programs.k8s.enable = lib.mkDefault true;
    bbennett.programs.neovim.enable = lib.mkDefault true;
    bbennett.programs.pkl.enable = lib.mkDefault true;
    bbennett.programs.python.enable = lib.mkDefault true;
    bbennett.programs.zig.enable = lib.mkDefault true;
    bbennett.programs.jule.enable = lib.mkDefault true;

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
      #      nur.repos.charmbracelet.crush

      bazel-buildtools
      bazelisk

      yarn
      nodejs # LTS
      prettier

      elixir
      gleam

      lldb

      rustup
    ];

    home.shellAliases = {
      bazel = "bazelisk";
    };
  };
}
