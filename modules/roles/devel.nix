{ self, ... }:
{
  flake.modules.homeManager.devel =
    { pkgs, ... }:
    {
      imports = [
        self.modules.homeManager.atlas
        self.modules.homeManager.cockroachdb
        self.modules.homeManager.git
        self.modules.homeManager.go
        self.modules.homeManager.jujutsu
        self.modules.homeManager.k8s
        self.modules.homeManager.pkl
        self.modules.homeManager.python
        self.modules.homeManager.zig
        self.modules.homeManager.jule
      ];

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
