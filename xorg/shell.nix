let
   pkgs = import (fetchTarball("channel:nixpkgs-unstable")) {};
in pkgs.mkShell {
  buildInputs = [
    # Rust toolchain
    pkgs.cargo
    pkgs.rustc
    pkgs.rustfmt

    # Dependencies
    pkgs.openssl
    pkgs.pkg-config
    pkgs.libxkbcommon
    pkgs.gcc
  ];

  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
