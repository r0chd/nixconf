inputs: config: [
  inputs.nixGL.overlay
  inputs.niri.overlays.niri
  inputs.deploy-rs.overlays.default

  (
    final: prev:
    let
      inherit (prev) system;
    in
    {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system;
        inherit (config.nixpkgs) config;
      };
      moxnotify = inputs.moxnotify.packages.${system}.default;
      moxctl = inputs.moxctl.packages.${system}.default;
      moxidle = inputs.moxidle.packages.${system}.default;
      moxpaper = inputs.moxpaper.packages.${system}.default;
      moxapi = inputs.moxapi.packages.${system}.default;
      seto = inputs.seto.packages.${system}.default;
      nh = inputs.nh.packages.${system}.default;
      sysnotifier = inputs.sysnotifier.packages.${system}.default;
      helix = inputs.helix-steel.packages.${system}.default;
      sccache = prev.callPackage ./sccache { };
      darkfi = prev.callPackage ./darkfi { };
    }
  )
]
