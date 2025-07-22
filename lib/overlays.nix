{ ... }:
{
  myPackages = final: prev: {
    litra-autotoggle = prev.callPackage ../pkgs/litra-autotoggle.nix { };
    # Add more custom packages here as they grow
  };
}
