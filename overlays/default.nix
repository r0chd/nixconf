inputs: config: [
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      inherit (config.nixpkgs) config;
    };
  })

  (final: prev: {
    moxnotify = inputs.moxnotify.packages.${prev.system}.default;
  })

  (final: prev: {
    moxctl = inputs.moxctl.packages.${prev.system}.default;
  })

  (final: prev: {
    moxidle = inputs.moxidle.packages.${prev.system}.default;
  })
]
