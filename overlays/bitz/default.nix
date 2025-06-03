{
  fetchFromGitHub,
  rustPlatform,
  perl,
}:
rustPlatform.buildRustPackage {
  pname = "bitz";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "JustPandaEver";
    repo = "bitz-cli";
    rev = "899cf277adf4c15a46b917154e0c953d3337b8b0";
    sha256 = "sha256-OTioCpciaD+6IuC/Gg8siUJzFQT2d1oBjbuGc+oDdM0=";
  };

  cargoHash = "sha256-ZU/+wxkpEPSaRafHR10q3Pp3haKmDimgMV8Rmr32L+w=";

  nativeBuildInputs = [ perl ];

  buildInputs = [ ];
}
