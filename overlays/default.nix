inputs: config: [
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      inherit (config.nixpkgs) config;
    };
    moxnotify = inputs.moxnotify.packages.${prev.system}.default;
    moxidle = inputs.moxidle.packages.${prev.system}.default;
    seto = inputs.seto.packages.${prev.system}.default;
    linuxPackages_latest = prev.linuxPackages_latest.extend (
      self: super: { broadcom_sta = self.callPackage ./broadcom-sta { }; }
    );
    hyprscroller = prev.callPackage ./hyprscroller {
      inherit (inputs.hyprland.packages.${prev.system}) hyprland;
      inherit (inputs) hyprscroller;
    };
    nh = inputs.nh.packages.${prev.system}.default;
    bitz = prev.callPackage ./bitz { };
  })

  inputs.niri.overlays.niri
  inputs.deploy-rs.overlay
  inputs.nixpkgs-wayland.overlay
  inputs.nix-minecraft.overlay
]
