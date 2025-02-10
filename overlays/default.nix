inputs: config: [
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      inherit (config.nixpkgs) config;
    };
  })
]
