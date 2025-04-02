{
  stdenv,
  hyprscroller,
  hyprland,
  ...
}:
stdenv.mkDerivation rec {
  name = "hyprscroller";
  pname = name;
  src = hyprscroller;

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
    cp -r ./Release/hyprscroller.so "$out/lib/lib${name}.so"
  '';
}
