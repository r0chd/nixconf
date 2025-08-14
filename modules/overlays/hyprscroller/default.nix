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
    rev = "d3e447a22cfaae77ab1cf3931d23cfdb7c010a9c";
    hash = "sha256-XqUm5nnTmZUF17eqEACzQCAWXF7ezLKHqIwJR/td34Y=";
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
