{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "starship-jj";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "lanastara_foss";
    repo = "starship-jj";
    rev = version;
    hash = "sha256-HTkDZQJnlbv2LlBybpBTNh1Y3/M8RNeQuiked3JaLgI=";
  };

  cargoHash = "sha256-E5z3AZhD3kiP6ojthcPne0f29SbY0eV4EYTFewA+jNc=";

  meta = with lib; {
    description = "starship plugin for jj";
    homepage = "https://gitlab.com/lanastara_foss/starship-jj";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
