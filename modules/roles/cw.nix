{self, ...}: {
  flake.modules = {
    darwin.cw = _: {
      homebrew.casks = [
        "1password"
        "google-drive"
        "slack"
      ];
    };

    homeManager.cw = {pkgs, ...}: {
      imports = [self.modules.homeManager.teleport];

      home.packages = with pkgs; [
        _1password-cli
        cloudsmith-cli
        doppler
        go-task
        backblaze-b2
      ];

      programs.go.env.GOPRIVATE = "github.com/coreweave/*";
    };
  };
}
