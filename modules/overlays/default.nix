inputs: config: [
  inputs.nixGL.overlay
  inputs.niri.overlays.niri
  inputs.mox-flake.overlays.default

  (
    final: prev:
    let
      inherit (prev.stdenv.hostPlatform) system;
    in
    {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (config.nixpkgs) config;
      };
      hyprscroller = prev.callPackage ./hyprscroller { };
      sysnotifier = inputs.sysnotifier.packages.${system}.default;
      darkfi = prev.callPackage ./darkfi { };
      pince = prev.callPackage ./pince { };
    }
  )
]
