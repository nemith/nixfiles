{inputs}: let
  overlays = import ./overlays.nix;
  builders = import ./builders.nix {inherit inputs overlays;};
in {
  inherit overlays builders;
  inherit (builders) mkNixosConfig mkDarwinConfig mkHomeConfig;
}
