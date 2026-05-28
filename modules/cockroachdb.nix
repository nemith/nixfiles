{ ... }:
let
  version = "26.2.1";

  sources = {
    aarch64-darwin = {
      plat = "darwin-11.0-arm64";
      hash = "sha256-UuliH4dP8FaXeAT6Px8D0POHvJcVqlhcbm9aGcinATY=";
    };
    x86_64-darwin = {
      plat = "darwin-10.9-amd64";
      hash = "sha256-R1G9qc/TDdmR+O1ifLvVE/T4vRqlDkbPelN3L7UEkm0=";
    };
    aarch64-linux = {
      plat = "linux-arm64";
      hash = "sha256-gUT4tFNkVfyzUH2TIW9S87LR1t1BXsJWb1PUdT8jxLQ=";
    };
    x86_64-linux = {
      plat = "linux-amd64";
      hash = "sha256-biLxmR6aBCvaOpiu+dM47hI/Wnd9OsLTqcL7/hkoL+0=";
    };
  };

  mkCockroachSql =
    pkgs:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      source =
        sources.${system}
          or (throw "cockroach-sql: unsupported platform ${system}");
    in
    pkgs.stdenv.mkDerivation {
      pname = "cockroach-sql";
      inherit version;

      src = pkgs.fetchurl {
        url = "https://binaries.cockroachdb.com/cockroach-sql-v${version}.${source.plat}.tgz";
        inherit (source) hash;
      };

      nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.autoPatchelfHook
      ];
      buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.stdenv.cc.cc.lib
      ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 cockroach-sql $out/bin/cockroach-sql
        install -Dm644 LICENSE -t $out/share/doc/cockroach-sql/
        install -Dm644 THIRD-PARTY-NOTICES.txt -t $out/share/doc/cockroach-sql/
        runHook postInstall
      '';

      meta = {
        description = "CockroachDB standalone SQL client";
        homepage = "https://www.cockroachlabs.com/";
        license = pkgs.lib.licenses.bsl11;
        platforms = builtins.attrNames sources;
        mainProgram = "cockroach-sql";
      };
    };
in
{
  flake.overlays.cockroach-sql = final: _prev: {
    cockroach-sql = mkCockroachSql final;
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.cockroach-sql = pkgs.cockroach-sql;
    };

  flake.modules.homeManager.cockroachdb =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.cockroach-sql ];
      home.shellAliases.csql = "cockroach-sql";
    };
}
