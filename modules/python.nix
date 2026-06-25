_: {
  flake.modules.homeManager.python = {
    lib,
    pkgs,
    ...
  }: let
    package = pkgs.python314;
    others = with pkgs; [
      python315
      python313
      python312
      python311
    ];
  in {
    home.packages =
      [
        pkgs.pre-commit
        pkgs.uv
        pkgs.poetry
        package
      ]
      ++ lib.imap1 (i: pkg: lib.meta.setPrio (10 + i) pkg) others;

    programs.ruff = {
      enable = true;
    };
  };
}
