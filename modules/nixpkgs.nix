{
  self,
  inputs,
  config,
  ...
}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowInsecurePredicate = pkg: builtins.elem (pkg.pname or "") ["librewolf" "librewolf-unwrapped"];
      overlays = builtins.attrValues config.flake.overlays;
    };
  };

  flake.modules.darwin.nixpkgs = _: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (pkg.pname or "") ["librewolf" "librewolf-unwrapped"];
    nixpkgs.overlays = builtins.attrValues self.overlays;
  };
}
