{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "litra-autotoggle";
  version = "0.6.1";
  useFetchCargoVendor = true;

  src = fetchFromGitHub {
    owner = "timrogers";
    repo = "litra-autotoggle";
    rev = "v${version}";
    sha256 = "sha256-CoP9t8uvErvP3sU51pfsjsY/xp/zXNVcgXP8WmONz60=";
  };

  cargoHash = "sha256-MCabivlj8ye8WKMFJ9oP5+J72D8Ib0xlYEOjLCUKjYg=";

  meta = with lib; {
    description = "Automatically controls Logitech Litra Glow lights based on webcam usage";
    homepage = "https://github.com/timrogers/litra-autotoggle";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
