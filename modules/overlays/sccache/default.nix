{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  distributed ? false,
}:
let
  version = "0.10.0";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-VEDMeRFQKNPS3V6/DhMWxHR7YWsCzAXTzp0lO+COl08=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1kfKBN4uRbU5LjbC0cLgMqoGnOSEAdC0S7EzXlfaDPo=";

  buildFeatures = lib.optionals distributed [
    "dist-client"
    "dist-server"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Tests fail because of client server setup which is not possible inside the
  # pure environment, see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = {
    description = "Ccache with Cloud Storage";
    mainProgram = "sccache";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${version}";
    maintainers = builtins.attrValues { inherit (lib.maintainers) unixpariah; };
    license = lib.licenses.asl20;
  };
}
