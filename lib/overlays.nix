final: prev: {
  litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle {};
  starship-jj = prev.callPackage ../pkgs/starship-jj {};

  # https://github.com/NixOS/nixpkgs/pull/486335/
  gdb =
    if prev.stdenv.isDarwin
    then
      prev.gdb.overrideAttrs (oldAttrs: {
        configureFlags =
          map
          (flag:
            if flag == "--enable-werror"
            then "--disable-werror"
            else flag)
          oldAttrs.configureFlags;
      })
    else prev.gdb;

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
