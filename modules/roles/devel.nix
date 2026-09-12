{ self, ... }: {
  flake.modules.homeManager.devel = { pkgs, lib, ... }: {
    imports = [
      self.modules.homeManager.atlas
      self.modules.homeManager.claude
      self.modules.homeManager.codex
      self.modules.homeManager.cockroachdb
      self.modules.homeManager.git
      self.modules.homeManager.go
      self.modules.homeManager.jujutsu
      self.modules.homeManager.k8s
      self.modules.homeManager.opencode
      self.modules.homeManager.pkl
      self.modules.homeManager.python
      self.modules.homeManager.zig
      self.modules.homeManager.jule
    ];

    home.packages = with pkgs; [
      ast-grep
      devenv
      flyctl
      gnumake
      grex
      grpcui
      grpcurl
      hexyl
      just
      lazydocker
      miniserve
      shellcheck
      shfmt
      sleek

      ansible
      ansible-lint

      postgresql_18
      pgcli
      harlequin

      scc
      tokei

      protobuf
      buf

      antigravity-cli
      github-copilot-cli

      bazel-buildtools
      # bazelisk bundles its own sha256sum, which collides with
      # uutils-coreutils-noprefix; lowPrio lets coreutils win on PATH.
      (lib.lowPrio bazelisk)

      yarn
      nodejs # LTS
      prettier

      beamPackages.elixir
      gleam

      lldb

      rustup
    ];

    home.shellAliases = {
      bazel = "bazelisk";
    };
  };
}
