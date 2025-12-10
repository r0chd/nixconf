{
  stdenv,
  fetchFromGitHub,
  hyprland,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "hyprscroller";
  pname = finalAttrs.name;
  src = fetchFromGitHub {
    owner = "cpiber";
    repo = "hyprscroller";
    rev = "99e0ac50d089f5f26f0b71fc2defb6862e2796be";
    hash = "sha256-lEUj6BMW3F42FzxymSJKvGqHXlhRRQ6Hqv7iU5c+iZ4=";
  };

  inherit (hyprland) buildInputs;
  nativeBuildInputs = hyprland.nativeBuildInputs ++ [ hyprland ];

  dontUseCmakeConfigure = true;
  dontUseMesonConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  buildPhase = ''
    cmake -B ./Release -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$(PREFIX)
    cmake --build ./Release -j
  '';

  installPhase = ''
    mkdir -p "$out/lib"
    cp -r ./Release/hyprscroller.so "$out/lib/lib${finalAttrs.name}.so"
  '';
})
