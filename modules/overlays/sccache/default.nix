{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  distributed ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sccache";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-VEDMeRFQKNPS3V6/DhMWxHR7YWsCzAXTzp0lO+COl08=";
  };

  cargoHash = "sha256-1kfKBN4uRbU5LjbC0cLgMqoGnOSEAdC0S7EzXlfaDPo=";

  buildFeatures = lib.optionals distributed [
    "dist-client"
    "dist-server"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = {
    description = "Ccache with Cloud Storage";
    mainProgram = "sccache";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${finalAttrs.version}";
    maintainers = builtins.attrValues { inherit (lib.maintainers) doronbehar figsoda; };
    license = lib.licenses.asl20;
  };
})
