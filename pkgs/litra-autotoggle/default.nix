{
  lib,
  fetchFromGitHub,
  rustPlatform,
  udev,
  pkg-config,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "litra-autotoggle";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "timrogers";
    repo = "litra-autotoggle";
    rev = "v${version}";
    sha256 = "sha256-CoP9t8uvErvP3sU51pfsjsY/xp/zXNVcgXP8WmONz60=";
  };

  cargoHash = "sha256-MCabivlj8ye8WKMFJ9oP5+J72D8Ib0xlYEOjLCUKjYg=";

  nativeBuildInputs = [pkg-config];
  buildInputs = lib.optionals stdenv.isLinux [udev];

  postInstall = lib.optionalString stdenv.isLinux ''
    install -Dm644 ${./litra-autotoggle.rules} $out/lib/udev/rules.d/99-litra-autotoggle.rules
  '';

  meta = with lib; {
    description = "Automatically controls Logitech Litra Glow lights based on webcam usage";
    homepage = "https://github.com/timrogers/litra-autotoggle";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
