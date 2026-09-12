{ inputs, config, ... }: {
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowInsecurePredicate =
        pkg:
        builtins.elem (pkg.pname or "") [
          "librewolf"
          "librewolf-unwrapped"
        ];
      overlays = builtins.attrValues config.flake.overlays;
    };
  };

  # Expose NUR's package set as pkgs.nur, built against our nixpkgs config
  # (allowUnfree) so unfree addons like the 1Password extension resolve.
  flake.overlays.nur = inputs.nur.overlays.default;

  flake.modules.darwin.nixpkgs = _: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowInsecurePredicate =
      pkg:
      builtins.elem (pkg.pname or "") [
        "librewolf"
        "librewolf-unwrapped"
      ];
    nixpkgs.overlays = builtins.attrValues config.flake.overlays;
  };
}
