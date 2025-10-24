final: prev: {
  litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle.nix {};
  starship-jj = prev.callPackage ../pkgs/starship-jj.nix {};

  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (
        _: python-prev: {
          # This fails to build only on gh darwin builders;
          dulwich = python-prev.dulwich.overridePythonAttrs (_: {
            doCheck = false;
          });
        }
      )
    ];

  # Fails on darwin
  sbcl = prev.sbcl.overrideAttrs (_: {
    doCheck = false;
  });

  # Disable failing tests until fixed upstream
  # See: https://github.com/NixOS/nixpkgs/pull/450487
  trurl = prev.trurl.overrideAttrs (_: {
    doCheck = false;
  });

  # No fucking clue why this one fails tests
  tealdeer = prev.tealdeer.overrideAttrs (_: {
    doCheck = false;
  });

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
