{
  lib,
  stdenv,
  wayland,
  wayland-scanner,
  wayland-protocols,
  zig,
  pkg-config,
  callPackage,
  tree_magic_mini,
  fetchFromGitea,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wl-clipboard-zig";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "forgejo.r0chd.pl";
    owner = "r0chd";
    repo = "wl-clipboard-zig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u6U194vR7VS/f60o9VOZ1d/W8mxEuqujB0IDNd0SVN4=";
  };

  dontConfigure = true;
  doCheck = false;

  nativeBuildInputs = [
    zig.hook
    wayland-scanner
    pkg-config
    wayland-protocols
  ];

  buildInputs = [
    wayland
    tree_magic_mini
  ];

  zigBuildFlags = [ "--release=fast" ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "";
    homepage = "https://forgejo.r0chd.pl/r0chd/wl-clipboard-zig";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
