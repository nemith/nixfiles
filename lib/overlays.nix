final: prev: {
  # Override python3 with the dulwich test fix
  python3 = prev.python3.override {
    packageOverrides = _: pyPrev: {
      dulwich = pyPrev.dulwich.overrideAttrs (_: {
        doCheck = !prev.stdenv.isDarwin;
      });
    };
  };

  python3Packages = final.python3.pkgs;

  litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle.nix {};
  starship-jj = prev.callPackage ../pkgs/starship-jj.nix {};

  # Build from master until 0.24.0 is released
  starship = prev.starship.overrideAttrs (_: rec {
    version = "0.24.0-prerelease1";
    src = prev.fetchFromGitHub {
      owner = "starship";
      repo = "starship";
      rev = "2c11c086b8da5ea43ae795fa0e71a621e983ebcc";
      hash = "sha256-+1PkDpHO+Ae52O1Reb+dcnmJ2g8HdriMgOQYLW4RY8A=";
    };
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-ltffMfuTt6v4Kzr5LCbMs2XyIQVhRSwItM1KSlSMyjY=";
    };
  });
}
