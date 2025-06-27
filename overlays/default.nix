inputs: config: [
  (
    final: prev: with prev; {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        inherit (config.nixpkgs) config;
      };
      moxnotify = inputs.moxnotify.packages.${system}.default;
      moxidle = inputs.moxidle.packages.${system}.default;
      moxpaper = inputs.moxpaper.packages.${system}.default;
      seto = inputs.seto.packages.${system}.default;
      nh = inputs.nh.packages.${system}.default;
      sysnotifier = inputs.sysnotifier.packages.${system}.default;
      helix = inputs.helix-steel.packages.${system}.default;
      nixGL = inputs.nixGL.overlay;
    }
  )

  inputs.niri.overlays.niri
  inputs.deploy-rs.overlays.default
  inputs.nixpkgs-wayland.overlay
]
