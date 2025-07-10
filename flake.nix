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
      treefmt,
      nix-raspberrypi,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      hostEval = nixpkgs.lib.evalModules {
        modules = [
          { _module.args.inputs = inputs; }
          ./configuration.nix
          ./options.nix
        ];
      };

      inherit (hostEval) config;

      mkHome =
        hostName: username:
        let
          system = config.hosts.${hostName}.system;
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
            inherit (config.hosts.${hostName}) platform profile;
          };

          modules = [
            ./modules/home
            stylix.homeModules.stylix
            inputs.nix-index-database.hmModules.nix-index
            {
              home = {
                inherit username;
                homeDirectory = config.hosts.${hostName}.users.${username}.home;
              };
            }
          ];
        };

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          function pkgs
        );
      inherit (nixpkgs) lib;
    in
    {
      deploy.nodes =
        let
          mkNode =
            hostname: attrs:
            let
              system = config.hosts.${hostname}.system;
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

              hostUsers = config.hosts.${hostname}.users or { };
              mkUserProfiles =
                users:
                users
                |> builtins.attrNames
                |> map (user: {
                  name = user;
                  value = {
                    inherit user;
                    profilePath = "/home/${user}/.local/state/nix/profiles/profile";
                    path = deployPkgs.deploy-rs.lib.activate.custom (mkHome hostname user).activationPackage "$PROFILE/activate";
                  };
                })
                |> lib.filterAttrs (_: attrs.platform != "mobile")
                |> builtins.listToAttrs;
            in
            {
              inherit hostname;
              sshUser = "deploy-rs";
              profiles = {
                system = {
                  user = "root";
                  path =
                    if config.hosts.${hostname}.platform == "nixos" then
                      deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.${hostname}
                    else if config.hosts.${hostname}.platform == "non-nixos" then
                      deployPkgs.deploy-rs.lib.activate.custom self.systemConfigs.${hostname}
                        "/nix/var/nix/profiles/system/activate"
                    else
                      deployPkgs.deploy-rs.lib.activate.custom self.nixOnDroidConfigurations.${hostname}
                        "/nix/var/nix/profiles/system/activate";
                };
              } // mkUserProfiles hostUsers;
            };
        in
        config.hosts |> lib.mapAttrs (hostname: attrs: mkNode hostname attrs);

      nixosConfigurations =
        let
          mkHost =
            hostName: attrs:
            let
              nixosSystem =
                if attrs.platform == "rpi-nixos" then nix-raspberrypi.lib.nixosSystem else nixpkgs.lib.nixosSystem;
            in
            nixosSystem {
              specialArgs = {
                inherit inputs hostName;
                systemUsers = attrs.users;
                inherit (config.hosts.${hostName}) system profile;
              };
              modules =
                [
                  ./modules/nixos
                  nix-gaming.nixosModules.pipewireLowLatency
                  nix-gaming.nixosModules.platformOptimizations
                  disko.nixosModules.default
                  stylix.nixosModules.stylix
                  nix-index-database.nixosModules.nix-index
                  { networking = { inherit hostName; }; }
                ]
                ++ lib.optionals (attrs.platform == "rpi-nixos") (
                  builtins.attrValues {
                    inherit (nixpkgs.nixos-raspberrypi.nixosModules.raspberry-pi-5) base display-vc4 bluetooth;
                  }
                );
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.platform == "nixos")
        |> lib.mapAttrs (hostName: attrs: mkHost hostName attrs);

      systemConfigs =
        let
          mkHost =
            hostName: attrs:
            let
              systemUsers = attrs.users;
              pkgs = import nixpkgs { inherit (attrs) system; };
            in
            system-manager.lib.makeSystemConfig {
              modules = [
                ./modules/system
                { networking = { inherit hostName; }; }
              ];
              extraSpecialArgs = {
                inherit inputs systemUsers pkgs;
                inherit (config.hosts.${hostName}) system profile;
              };
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.platform == "non-nixos")
        |> lib.mapAttrs (hostName: attrs: mkHost hostName attrs);

      homeConfigurations =
        config.hosts
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
              system = config.hosts.${hostName}.system;
            in
            nix-on-droid.lib.nixOnDroidConfiguration {
              pkgs = import nixpkgs { inherit system; };
              modules = [
                ./hosts/${hostName}
                ./modules/nixOnDroid
              ];
            };
        in
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.platform == "mobile")
        |> lib.mapAttrs (hostName: attrs: mkDroid hostName attrs);

      checks = lib.lists.foldl' lib.attrsets.unionOfDisjoint { } [
        (deploy-rs.lib."x86_64-linux".deployChecks self.deploy)
        {
          treefmt-check = forAllSystems (
            pkgs: (treefmt.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper
          );
        }
      ];

      formatter = forAllSystems (pkgs: (treefmt.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper);

      devShells =
        let
          forAllSystems =
            function:
            nixpkgs.lib.genAttrs systems (
              system:
              let
                pkgs = import nixpkgs {
                  inherit system;
                  config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "terraform" ];
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
      inputs.home-manager.follows = "home-manager";
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
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    seto.url = "github:unixpariah/seto";
    moxidle.url = "github:unixpariah/moxidle";
    moxnotify.url = "github:unixpariah/moxnotify";
    moxctl.url = "github:unixpariah/moxctl";
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
