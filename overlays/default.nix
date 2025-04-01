inputs: config: [
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      inherit (config.nixpkgs) config;
    };
    moxnotify = inputs.moxnotify.packages.${prev.system}.default;
    moxidle = inputs.moxidle.packages.${prev.system}.default;
    seto = inputs.seto.packages.${prev.system}.default;
  })

  inputs.deploy-rs.overlay
  inputs.nixpkgs-wayland.overlay
]
