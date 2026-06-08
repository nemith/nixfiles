{
  self,
  inputs,
  config,
  ...
}:
{
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = builtins.attrValues config.flake.overlays;
    };
  };

  flake.modules.darwin.nixpkgs = _: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = builtins.attrValues self.overlays;
  };
}
