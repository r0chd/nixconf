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
      sysnotifier = inputs.sysnotifier.packages.${system}.default;
      pince = prev.callPackage ./pince { };
      river = prev.callPackage ./river { };
    }
  )
]
