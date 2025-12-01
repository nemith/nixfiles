_: prev: {
  litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle.nix {};
  starship-jj = prev.callPackage ../pkgs/starship-jj.nix {};

  # temp disable checks for fish
  # https://github.com/NixOS/nixpkgs/pull/462589
  fish = prev.fish.overrideAttrs (_: {
    doCheck = false;
  });

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

          # fix hash  https://github.com/NixOS/nixpkgs/pull/466184
          mitmproxy-macos = python-prev.mitmproxy-macos.overridePythonAttrs (oldAttrs: rec {
            src = oldAttrs.src.override {
              hash = "sha256-baAfEY4hEN3wOEicgE53gY71IX003JYFyyZaNJ7U8UA=";
            };
          });

        }
      )
    ];
}
