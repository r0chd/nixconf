inputs: config: [
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      inherit (config.nixpkgs) config;
    };
    moxnotify = inputs.moxnotify.packages.${prev.system}.default;
    moxctl = inputs.moxctl.packages.${prev.system}.default;
    moxidle = inputs.moxidle.packages.${prev.system}.default;
  })

  #inputs.nixpkgs-wayland.overlay
]
