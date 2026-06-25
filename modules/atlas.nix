_: let
  version = "1.2.1";

  sources = {
    aarch64-darwin = {
      plat = "darwin-arm64";
      hash = "sha256-d5KHaWq5zTHFg6MZYzNNBWp0mMfTv0ZnZxCe2XlLa4c=";
    };
    aarch64-linux = {
      plat = "linux-arm64";
      hash = "sha256-oAflvgOopE3MiULWFLQElma08G4M4hxGPRG0mwb34/s=";
    };
    x86_64-linux = {
      plat = "linux-amd64";
      hash = "sha256-T5YcF5mJdcJ8aTcy3+aNCHPKWWgqLmyJC2nUmJob7dM=";
    };
  };

  mkAtlas = pkgs: let
    inherit (pkgs.stdenv.hostPlatform) system;
    source = sources.${system} or (throw "atlas: unsupported platform ${system}");
  in
    pkgs.stdenv.mkDerivation {
      pname = "atlas";
      inherit version;

      src = pkgs.fetchurl {
        url = "https://release.ariga.io/atlas/atlas-${source.plat}-v${version}";
        inherit (source) hash;
      };

      nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.autoPatchelfHook];
      buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.stdenv.cc.cc.lib];

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 $src $out/bin/atlas
        runHook postInstall
      '';

      meta = {
        description = "Atlas schema-as-code CLI (extended distribution from release.ariga.io)";
        homepage = "https://atlasgo.io/";
        license = pkgs.lib.licenses.unfree;
        platforms = builtins.attrNames sources;
        mainProgram = "atlas";
      };
    };
in {
  flake.overlays.atlas = _final: _prev: {atlas = mkAtlas _final;};

  perSystem = {pkgs, ...}: {packages.atlas = pkgs.atlas;};

  flake.modules.homeManager.atlas = {pkgs, ...}: {home.packages = [pkgs.atlas];};
}
