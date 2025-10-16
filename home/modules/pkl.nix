{
  pkgs,
  lib,
  config,
  ...
}: let
  pkl-vscode = pkgs.vscode-utils.buildVscodeExtension {
    pname = "pkl-vscode";
    version = "0.20.0";

    src = pkgs.fetchurl {
      url = "https://github.com/apple/pkl-vscode/releases/download/0.20.0/pkl-vscode-0.20.0.vsix";
      sha256 = "sha256-bLhevJR6+qBWTTNiOAmkslNa6GNFruuE5LS/DRnMjss=";
    };

    dontUnpack = true;

    vscodeExtPublisher = "apple";
    vscodeExtName = "pkl-vscode";
    vscodeExtUniqueId = "apple.pkl-vscode";
  };
  jdk = pkgs.jdk25 or pkgs.jdk24;
in {
  options = {
    bbennett.pkl.enable = lib.mkEnableOption "pkl configuraiton language";
  };

  config = lib.mkIf config.bbennett.pkl.enable {
    home.packages = with pkgs; [
      pkl
      jdk
    ];

    programs.vscode = {
      profiles.default = {
        extensions = [
          pkl-vscode
        ];
        userSettings = {
          "pkl.javaHome" = "${jdk}";
        };
      };
    };
  };
}
