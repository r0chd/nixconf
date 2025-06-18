inputs: config: [
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      inherit (config.nixpkgs) config;
    };
    moxnotify = inputs.moxnotify.packages.${prev.system}.default;
    moxidle = inputs.moxidle.packages.${prev.system}.default;
    moxpaper = inputs.moxpaper.packages.${prev.system}.default;
    seto = inputs.seto.packages.${prev.system}.default;
    nh = inputs.nh.packages.${prev.system}.default;
    sysnotifier = inputs.sysnotifier.packages.${prev.system}.default;
    helix = prev.callPackage ./helix { };
  })

  inputs.niri.overlays.niri
  inputs.deploy-rs.overlays.default
  inputs.nixpkgs-wayland.overlay
  inputs.nix-minecraft.overlay
]
