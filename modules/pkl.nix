{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.pkl-vscode = pkgs.vscode-utils.buildVscodeExtension {
        pname = "pkl-vscode";
        version = "0.20.0";

        src = pkgs.fetchurl {
          url = "https://github.com/apple/pkl-vscode/releases/download/0.22.0/pkl-vscode-0.22.0.vsix";
          sha256 = "sha256-T/ZNzZDgl8KwSPYx4g+bvcEr1AXC9UO0CtMr5WNExzA=";
        };

        dontUnpack = true;

        vscodeExtPublisher = "apple";
        vscodeExtName = "pkl-vscode";
        vscodeExtUniqueId = "apple.pkl-vscode";
      };
    };

  flake.modules.homeManager.pkl =
    { pkgs, ... }:
    let
      jdk = "${pkgs.pkl.passthru.jdk or pkgs.temurin-bin-21}";
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      home.packages = [
        pkgs.pkl
        jdk
      ];

      programs.vscode.profiles.default = {
        extensions = [ self.packages.${system}.pkl-vscode ];
        userSettings = {
          "pkl.javaHome" = "${jdk}";
        };
      };
    };
}
