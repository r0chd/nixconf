inputs: config: [
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config = config.nixpkgs.config;
    };
  })
]
