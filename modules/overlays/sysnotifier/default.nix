{
  rustPlatform,
  lib,
  libpulseaudio,
  pkg-config,
}:

let
  cargoToml = builtins.fromTOML (builtins.readFile ../Cargo.toml);
in
rustPlatform.buildRustPackage {
  pname = "sysnotifier";
  inherit (cargoToml.package) version;

  cargoLock.lockFile = ../Cargo.lock;

  src = lib.cleanSourceWith {
    src = ../.;
    filter =
      path: type:
      let
        relPath = lib.removePrefix (toString ../. + "/") (toString path);
      in
      lib.any (p: lib.hasPrefix p relPath) [
        "src"
        "Cargo.toml"
        "Cargo.lock"
      ];
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpulseaudio ];

  buildPhase = ''
    cargo build --release --workspace
  '';

  configurePhase = ''
    export PKG_CONFIG_PATH=${libpulseaudio.dev}/lib/pkgconfig
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/release/sysnotifier $out/bin/
  '';

  doCheck = false;

  meta = {
    description = "Pulse Audio and Notification bridge";
    homepage = "https://github.com/unixpariah/SysNotifier";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.unixpariah ];
    platforms = lib.platforms.linux;
    mainProgram = "sysnotifier";
  };
}
