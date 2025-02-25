{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "litra-autotoggle";
  version = "0.6.1"; # Update this based on the latest tag/release

  src = fetchFromGitHub {
    owner = "timrogers";
    repo = "litra-autotoggle";
    rev = "${version}";
    sha256 = "sha256-CoP9t8uvErvP3sU51pfsjsY/xp/zXNVcgXP8WmONz60=";
  };

  cargoSha256 = "sha256-jK4XfdJIXgr523hcvdDRUspI8/msIwqYmvpzBOFi0lk=";

  meta = with lib; {
    description = "Automatically controls Logitech Litra Glow lights based on webcam usage";
    homepage = "https://github.com/timrogers/litra-autotoggle";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
