{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      treefmt = inputs.treefmt-nix.lib.mkWrapper pkgs {
        programs.nixfmt = {
          enable = true;
          strict = true;
        };
        programs.statix.enable = true;
        programs.deadnix.enable = true;

        programs.stylua.enable = true;
        programs.yamlfmt.enable = true;
        programs.mdformat.enable = true;
      };
    in
    {
      formatter = treefmt;
    };
}
