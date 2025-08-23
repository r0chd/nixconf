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
      nix-on-droid,
      system-manager,
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
          ./utils/options.nix
        ];
      };

      inherit (hostEval) config;

      mkHome =
        hostName: username:
        let
          pkgs = import nixpkgs {
            inherit (config.hosts.${hostName}) system;
          };
          shell = "${config.hosts.${hostName}.users.${username}.shell}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs shell;
            inherit (config.hosts.${hostName}) platform profile;
          };

          modules = [
            ./modules/home
            ./modules/common/home
            ./hosts/${hostName}/users/${username}
            stylix.homeModules.stylix
            {
              networking = { inherit hostName; };
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
              pkgs = import nixpkgs { inherit (config.hosts.${hostname}) system; };
              inherit (pkgs) lib;
              deployPkgs = import nixpkgs {
                inherit (config.hosts.${hostname}) system;
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
                |> lib.mapAttrsToList (
                  user: attrs: {
                    name = user;
                    value = {
                      inherit user;
                      profilePath = "${attrs.home}/.local/state/nix/profiles/profile";
                      path = deployPkgs.deploy-rs.lib.activate.custom (mkHome hostname user).activationPackage "$PROFILE/activate";
                    };
                  }
                )
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
              }
              // mkUserProfiles hostUsers;
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
                inherit inputs;
                systemUsers = attrs.users;
                inherit (config.hosts.${hostName}) system profile;
              };
              modules = [
                ./modules/nixos
                ./modules/common/nixos
                ./hosts/${hostName}
                disko.nixosModules.default
                stylix.nixosModules.stylix
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
                ./hosts/${hostName}
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
        |> lib.filterAttrs (_: attrs: attrs.platform != "mobile")
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
            nix-on-droid.lib.nixOnDroidConfiguration {
              pkgs = import nixpkgs { inherit (config.hosts.${hostName}) system; };
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
      ];

      formatter = forAllSystems (
        pkgs:
        pkgs.writeShellApplication {
          name = "nix3-fmt-wrapper";

          runtimeInputs = [
            pkgs.nixfmt-rfc-style
            pkgs.fd
          ];

          text = ''
            fd "$@" -t f -e nix -x nixfmt -q '{}'
          '';
        }
      );
    };

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    niri.url = "github:sodiboo/niri-flake";

    nixvim = {
      url = "github:unixpariah/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    moxidle.url = "github:mox-desktop/moxidle";
    moxnotify.url = "github:mox-desktop/moxnotify";
    moxctl.url = "github:mox-desktop/moxctl";
    moxpaper.url = "github:mox-desktop/moxpaper";
    moxapi.url = "github:mox-desktop/moxapi";
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
