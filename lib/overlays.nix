final: prev: {
  litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle {};
  starship-jj = prev.callPackage ../pkgs/starship-jj {};

  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (_: python-prev: {
        # https://github.com/NixOS/nixpkgs/pull/490176
        rapidfuzz = python-prev.rapidfuzz.overridePythonAttrs (old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ final.lib.optionals final.stdenv.cc.isClang [
              final.clang-tools
            ];
        });
      })
    ];

  # Click API changed for version 8.2, causing test failures
  cloudsmith-cli = prev.cloudsmith-cli.overrideAttrs (oldAttrs: {
    postPatch =
      (oldAttrs.postPatch or "")
      + prev.lib.optionalString
      (prev.lib.versionAtLeast prev.python3Packages.click.version "8.2")
      ''
        substituteInPlace cloudsmith_cli/cli/tests/conftest.py \
          --replace 'click.testing.CliRunner(mix_stderr=False)' \
                    'click.testing.CliRunner()'
      '';
  });
}
