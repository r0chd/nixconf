let
  sources = import ./npins;
  # Import all the inputs from npins
  nixpkgs = import sources.nixpkgs { };
  nixpkgs-stable = import sources.nixpkgs-stable { };

  # Create inputs structure similar to flake inputs
  inputs = {
    inherit nixpkgs nixpkgs-stable;
    home-manager = import sources.home-manager;
    disko = import sources.disko;
    stylix = import sources.stylix;
    deploy-rs = import sources.deploy-rs;
    nix-gaming = import sources.nix-gaming;
    nix-index-database = import sources.nix-index-database;
    nix-on-droid = import sources.nix-on-droid;
    system-manager = import sources.system-manager;
    treefmt = import sources.treefmt-nix;
    nix-raspberrypi = import sources.nixos-raspberrypi;
    lix-module = import sources.lix-module;
    nixpkgs-wayland = import sources.nixpkgs-wayland;
    sops-nix = import sources.sops-nix;
    impermanence = import sources.impermanence;
    firefox-addons = import sources.firefox-addons;
    lanzaboote = import sources.lanzaboote;
    niri = import sources.niri-flake;
    zen-browser = import sources.zen-browser-flake;
    nixcord = import sources.nixcord;
    nixvim = import sources.nixvim;
    hyprland = import sources.Hyprland;
    hyprland-plugins = import sources.hyprland-plugins;
    helix-steel = import sources.helix;
    nixGL = import sources.nixGL;
    waybar = import sources.Waybar;
    seto = import sources.seto;
    moxidle = import sources.moxidle;
    moxnotify = import sources.moxnotify;
    moxctl = import sources.moxctl;
    moxpaper = import sources.moxpaper;
    moxapi = import sources.moxapi;
    nh = import sources.nh;
    nh-system = import sources.nh-system;
    sysnotifier = import sources.SysNotifier;
  };

  # Host evaluation (adapted from your flake)
  hostEval = nixpkgs.lib.evalModules {
    modules = [
      { _module.args.inputs = inputs; }
      ./configuration.nix
      ./utils/options.nix
    ];
  };

  inherit (hostEval) config;
  inherit (nixpkgs) lib;

  # Home Manager configuration function
  mkHome =
    hostName: username:
    let
      pkgs = import nixpkgs {
        inherit (config.hosts.${hostName}) system;
      };
      shell = "${config.hosts.${hostName}.users.${username}.shell}";
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs shell;
        inherit (config.hosts.${hostName}) platform profile;
      };
      modules = [
        ./modules/home
        ./modules/common/home
        ./hosts/${hostName}/users/${username}
        inputs.stylix.homeModules.stylix
        inputs.nix-index-database.homeModules.nix-index
        {
          networking = { inherit hostName; };
          home = {
            inherit username;
            homeDirectory = config.hosts.${hostName}.users.${username}.home;
          };
        }
      ];
    };

  # NixOS system builder
  mkNixOSHost =
    hostName: attrs:
    let
      nixosSystem =
        if attrs.platform == "rpi-nixos" then
          inputs.nix-raspberrypi.lib.nixosSystem
        else
          nixpkgs.lib.nixosSystem;
    in
    nixosSystem {
      specialArgs = {
        inherit inputs;
        systemUsers = attrs.users;
        inherit (config.hosts.${hostName}) system profile;
      };
      modules = [
        ./modules/nixos
        ./modules/common/nixos
        ./hosts/${hostName}
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.disko.nixosModules.default
        inputs.stylix.nixosModules.stylix
        inputs.nix-index-database.nixosModules.nix-index
        { networking = { inherit hostName; }; }
      ]
      ++ lib.optionals (attrs.platform == "rpi-nixos") (
        builtins.attrValues {
          inherit (inputs.nix-raspberrypi.nixosModules.raspberry-pi-5)
            base
            display-vc4
            bluetooth
            ;
        }
      );
    };

in
{
  # Main NixOS configurations
  nixosConfigurations = lib.mapAttrs mkNixOSHost (
    lib.filterAttrs (_: attrs: attrs.platform == "nixos") config.hosts
  );

  # System Manager configurations (for non-NixOS)
  systemConfigs =
    let
      mkSystemHost =
        hostName: attrs:
        let
          systemUsers = attrs.users;
          pkgs = import nixpkgs { inherit (attrs) system; };
        in
        inputs.system-manager.lib.makeSystemConfig {
          modules = [
            ./modules/system
            ./hosts/${hostName}
          ];
          extraSpecialArgs = {
            inherit inputs systemUsers pkgs;
            inherit (config.hosts.${hostName}) system profile;
          };
        };
    in
    lib.mapAttrs mkSystemHost (lib.filterAttrs (_: attrs: attrs.platform == "non-nixos") config.hosts);

  # Home Manager configurations
  homeConfigurations =
    let
      nonMobileHosts = lib.filterAttrs (_: attrs: attrs.platform != "mobile") config.hosts;
      hostUserPairs = builtins.concatLists (
        builtins.map (
          host:
          builtins.map (user: {
            name = "${user}@${host}";
            value = mkHome host user;
          }) (builtins.attrNames config.hosts.${host}.users)
        ) (builtins.attrNames nonMobileHosts)
      );
    in
    builtins.listToAttrs hostUserPairs;

  # For quick testing - simple nixos system
  testSystem = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      {
        networking.hostName = "test-system";
        system.stateVersion = "24.05";
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        networking.networkmanager.enable = true;
        services.openssh.enable = true;
        users.users.testuser = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
          initialPassword = "changeme";
        };
        security.sudo.wheelNeedsPassword = false;
      }
    ];
  };
}
