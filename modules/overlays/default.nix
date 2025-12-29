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
      tree_magic_mini = prev.callPackage ./tree_magic_mini { };
      wl-clipboard-zig = prev.callPackage ./wl-clipboard-zig { };
      whydotool = prev.callPackage ./whydotool { };
    }
  )
]
