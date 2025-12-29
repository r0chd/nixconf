{
  rustPlatform,
  lib,
  pkg-config,
  libxkbcommon,
  wayland,
  pipewire,
  llvmPackages_20,
  clangStdenv,
  fetchFromGitea,
  portals ? true,
}:
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "whydotool";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "forgejo.r0chd.pl";
    owner = "r0chd";
    repo = "whydotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kaJrb1NgHOpUIJAht4VIrmD3kYgHb/Y4vXV6ZAUIP34=";
  };

  cargoHash = "sha256-4cGl5bnMJfF6VHfNnY6Pn4O645mxc2GuQH7Jqwg+JIY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    wayland
  ]
  ++ lib.optionals portals [
    pipewire
  ];

  LIBCLANG_PATH = "${llvmPackages_20.libclang.lib}/lib";

  buildNoDefaultFeatures = true;
  cargoFeatures = lib.optionals portals [ "portals" ];

  meta = {
    description = "Wayland-native command-line automation tool.";
    homepage = "https://forgejo.r0chd.pl/r0chd/whydotool";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "whydotool";
  };
})
