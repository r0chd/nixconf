{
  fetchFromGitHub,
  rustPlatform,
  lib,
  gcc,
  stdenv,
  rust-cbindgen,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tree_magic_mini";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "r0chd";
    repo = "tree_magic";
    rev = "80b100e63665e8c48cebe62c2cd50b91cae32dd0";
    hash = "sha256-Ju4RKvk5mLsVasMotjJZEBUZQidmtStY8vV9AAzsRko=";
  };

  cargoHash = "sha256-InwtLMkd7VkY1kkhQczUg5tqNd2a+/6qRbT34vckB0w=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rust-cbindgen
  ];

  buildInputs = [
    gcc
  ];

  postInstall = ''
    mkdir -p $out/include  
    cbindgen --config cbindgen.toml --crate tree_magic_mini --output $out/include/tree_magic_mini.h --lang C

    mkdir -p $out/lib  
    cp target/${stdenv.hostPlatform.rust.rustcTarget}/release/libtree_magic_mini${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib

    mkdir -p $out/lib/pkgconfig

    sed \
      -e "s|@PREFIX@|$out|g" \
      -e "s|@INCLUDE@|$out/include|g" \
      -e "s|@LIBDIR@|$out/lib|g" \
      -e "s|@VERSION@|${finalAttrs.version}|g" \
      < ./tree_magic_mini.pc.in > $out/lib/pkgconfig/tree_magic_mini.pc
  '';

  doCheck = false;

  meta = {
    description = "Determines the MIME type of a file by traversing a filetype tree.";
    homepage = "https://github.com/mbrubeck/tree_magic";
    license = lib.licenses.gpl3;
    # maintainers = builtins.attrValues { inherit (lib.maintainers) r0chd; };
    platforms = lib.platforms.all;
  };
})
