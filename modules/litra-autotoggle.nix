{ self, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.litra-autotoggle = pkgs.rustPlatform.buildRustPackage rec {
      pname = "litra-autotoggle";
      version = "1.4.0";

      src = pkgs.fetchFromGitHub {
        owner = "timrogers";
        repo = "litra-autotoggle";
        rev = "v${version}";
        sha256 = "sha256-fx3j3LIdiSqnsNb66BRzz/q1qlLbPsfrtfKFKesJw0k=";
      };

      cargoHash = "sha256-jCLUdPUGdhFTysKLCqE1JGfUVzzDdvQDFPnelyQcDSY=";

      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = lib.optionals pkgs.stdenv.isLinux [ pkgs.udev ];

      #postInstall = lib.optionalString pkgs.stdenv.isLinux ''
      #  install -Dm644 ${./litra-autotoggle.rules} $out/lib/udev/rules.d/99-litra-autotoggle.rules
      #'';

      meta = with lib; {
        description = "Automatically controls Logitech Litra Glow lights based on webcam usage";
        homepage = "https://github.com/timrogers/litra-autotoggle";
        license = licenses.mit;
        platforms = platforms.darwin; # platforms.linux ++ platforms.darwin;
      };
    };
  };

  flake.modules.homeManager.litra-autotoggle =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.litra-autotoggle;
    in
    {
      launchd.agents.litra-autotoggle = lib.mkIf pkgs.stdenv.isDarwin {
        enable = true;
        config = {
          ProgramArguments = [ "${package}/bin/litra-autotoggle" ];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "${config.home.homeDirectory}/.local/state/litra-autotoggle/log";
          ThrottleInterval = 30;
        };
      };
    };
}
