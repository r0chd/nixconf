{
  rustPlatform,
  glib,
  glibc,
  fetchFromGitHub,
  llvmPackages_latest,
  alsa-lib,
  sqlite,
  pkg-config,
  sqlcipher,
  gnumake,
  cmake,
  clang,
  git,
  openssl,
  wabt,
  jq,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "darkirc";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "darkrenaissance";
    repo = "darkfi";
    rev = "v${version}";
    hash = "sha256-TFYPJfVeo730c/Gj8FXaV29mXxLsw/18XtrwPgnMaXg=";
  };

  cargoHash = "sha256-jte6qRb9lEfMPYV7ZcGPlCLGOdhA+HBHLTycQmwNaPo=";

  # Disable tests for now
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    cmake
    gnumake
    clang
    git
    wabt
    jq
  ];

  buildInputs = [
    alsa-lib
    sqlite
    sqlcipher
    openssl
    glibc
    glib
    llvmPackages_latest.libclang.lib
  ];

  # Use make to build exactly like the upstream Makefile
  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    export CARGO_NET_GIT_FETCH_WITH_CLI=true

    # Build zkas compiler first (required for proof circuits)
    cargo build --release --bin zkas

    # Navigate to IRC client directory and use its Makefile
    cd bin/darkirc  # Adjust path if needed

    # Use the Makefile which handles everything properly
    make all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # The Makefile copies the binary to the IRC directory
    cp bin/darkirc/darkirc $out/bin/darkirc

    runHook postInstall
  '';

  # Environment variables for compilation
  LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages_latest.libclang.lib ];
  BINDGEN_EXTRA_CLANG_ARGS = (builtins.map (a: ''-I"${a}/include"'') [ glibc.dev ]) ++ [
    ''-I"${llvmPackages_latest.libclang.lib}/lib/clang/${llvmPackages_latest.libclang.version}/include"''
    ''-I"${glib.dev}/include/glib-2.0"''
    "-I${glib.out}/lib/glib-2.0/include/"
  ];

  meta = with lib; {
    description = "DarkFi IRC client - Anonymous IRC client";
    homepage = "https://dark.fi";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
