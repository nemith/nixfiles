_: prev: {
  litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle.nix {};
  starship-jj = prev.callPackage ../pkgs/starship-jj.nix {};

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
}
