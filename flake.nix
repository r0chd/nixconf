{
  description = "My nixconfig";

  outputs =
    {
      self,
      nixpkgs,
      disko,
      home-manager,
      stylix,
      deploy-rs,
      nix-gaming,
      nix-index-database,
      nix-on-droid,
      system-manager,
      ...
    }@inputs:
    let
      hostEval = nixpkgs.lib.evalModules {
        modules = [
          { _module.args.inputs = inputs; }
          ./configuration.nix
          ./options.nix
        ];
      };

      config = hostEval.config;

      mkHome =
        hostName: username:
        let
          system = config.hosts.${hostName}.arch;
          pkgs = import nixpkgs { inherit system; };
          shell = "${config.hosts.${hostName}.users.${username}.shell}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              username
              hostName
              shell
              ;
            system_type = config.hosts.${hostName}.type;
            platform = config.hosts.${hostName}.platform;
          };

          modules = [
            ./homeModules
            stylix.homeModules.stylix
            inputs.nix-index-database.hmModules.nix-index
          ];
        };
    in
    with nixpkgs;
    {
      deploy.nodes =
        let
          mkNode =
            hostName: attrs:
            let
              system = config.hosts.${hostName}.arch;
              pkgs = import nixpkgs { inherit system; };
              deployPkgs = import nixpkgs {
                inherit system;
                overlays = [
                  deploy-rs.overlays.default
                  (self: super: {
                    deploy-rs = {
                      inherit (pkgs) deploy-rs;
                      inherit (super.deploy-rs) lib;
                    };
                  })
                ];
              };

              hostUsers = config.hosts.${hostName}.users or { };
              mkUserProfiles =
                users:
                users
                |> builtins.attrNames
                |> map (user: {
                  name = user;
                  value = {
                    inherit user;
                    profilePath = "/home/${user}/.local/state/nix/profiles/profile";
                    path = deployPkgs.deploy-rs.lib.activate.custom (mkHome hostName user).activationPackage "$PROFILE/activate";
                  };
                })
                |> builtins.listToAttrs;
            in
            {
              hostname = hostName;
              #sshUser = "deploy-rs";
              profiles = {
                system = {
                  user = "root";
                  path =
                    if config.hosts.${hostName}.platform == "nixos" then
                      deployPkgs.deploy-rs.lib.activate.nixos (self.nixosConfigurations.${hostName})
                    else
                      deployPkgs.deploy-rs.lib.activate.custom self.systemConfigs.${hostName}
                        "/nix/var/nix/profiles/system/activate";
                };
              } // mkUserProfiles hostUsers;
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile")
        |> lib.mapAttrs (hostName: attrs: mkNode hostName attrs);

      nixosConfigurations =
        let
          mkHost =
            hostName: attrs:
            let
              systemUsers = attrs.users;
              system_type = config.hosts.${hostName}.type;
              arch = config.hosts.${hostName}.arch;
            in
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit
                  inputs
                  hostName
                  systemUsers
                  system_type
                  arch
                  ;
              };

              modules = [
                ./nixModules
                nix-gaming.nixosModules.pipewireLowLatency
                nix-gaming.nixosModules.platformOptimizations
                disko.nixosModules.default
                stylix.nixosModules.stylix
                nix-index-database.nixosModules.nix-index
              ];
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile" && attrs.platform == "nixos")
        |> lib.mapAttrs (hostName: attrs: mkHost hostName attrs);

      systemConfigs =
        let
          mkHost =
            hostName: attrs:
            let
              systemUsers = attrs.users;
              system_type = config.hosts.${hostName}.type;
              arch = config.hosts.${hostName}.arch;
            in
            system-manager.lib.makeSystemConfig {
              modules = [ ./systemModules ];
              extraSpecialArgs = {
                inherit
                  inputs
                  hostName
                  systemUsers
                  system_type
                  arch
                  ;
              };
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile" && attrs.platform == "non-nixos")
        |> lib.mapAttrs (hostName: attrs: mkHost hostName attrs);

      homeConfigurations =
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile")
        |> builtins.attrNames
        |> builtins.map (
          host:
          config.hosts.${host}.users
          |> builtins.attrNames
          |> builtins.map (user: {
            name = "${user}@${host}";
            value = mkHome host user;
          })
        )
        |> builtins.concatLists
        |> builtins.listToAttrs;

      nixOnDroidConfigurations =
        let
          mkDroid =
            hostName: attrs:
            let
              system = config.hosts.${hostName}.arch;
            in
            nix-on-droid.lib.nixOnDroidConfiguration {
              pkgs = import nixpkgs { inherit system; };
              modules = [ ./hosts/${hostName} ];
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "server" && attrs.type != "desktop")
        |> lib.mapAttrs (hostName: attrs: mkDroid hostName attrs);

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells =
        let
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
          forAllSystems =
            function:
            nixpkgs.lib.genAttrs systems (
              system:
              let
                pkgs = import nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
              in
              function pkgs
            );
        in
        forAllSystems (pkgs: {
          default = import ./shell.nix { inherit pkgs; };
        });
    };

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:unixpariah/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    helix-steel = {
      url = "github:mattwparas/helix/steel-event-system";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    userborn = {
      url = "github:nikstur/userborn";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    seto.url = "github:unixpariah/seto";
    moxidle.url = "github:unixpariah/moxidle";
    moxnotify.url = "github:unixpariah/moxnotify";
    moxpaper.url = "github:unixpariah/moxpaper";
    nh = {
      url = "github:unixpariah/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh-system = {
      url = "github:unixpariah/nh/system-manager-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sysnotifier = {
      url = "github:unixpariah/SysNotifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
