{
  fetchFromGitHub,
  rustPlatform,
  perl,
}:
rustPlatform.buildRustPackage {
  pname = "bitz";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "needmorebitz";
    repo = "bitz-cli";
    rev = "46f8c86d6255324c35fb61644a99bd40026dcf03";
    sha256 = "sha256-gWn8IyhECSlrDcKoyAFDYEz/nlM8fUXUlcktOsCuvnQ=";
  };

  cargoHash = "sha256-3qm5/uLMZwIHQbmYG/GyeAtp7XGZdUiV6htTQT1B+SA=";

  nativeBuildInputs = [ perl ];

  buildInputs = [ ];
}
