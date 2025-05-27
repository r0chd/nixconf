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
      nix-minecraft,
      nix-on-droid,
      ...
    }@inputs:
    let
      hosts = {
        laptop = {
          arch = "x86_64-linux";
          type = "desktop";
          users = {
            unixpariah = {
              root.enable = true;
              shell = "nushell";
            };
            #test = {
            #root.enable = true;
            #shell = "nushell";
            #};
          };
        };
        rpi = {
          arch = "aarch64-linux";
          type = "server";
          users = {
            unixpariah = {
              root.enable = true;
              shell = "nushell";
            };
          };
        };
        laptop-lenovo = {
          arch = "x86_64-linux";
          type = "server";
          users.unixpariah = {
            root.enable = true;
            shell = "nushell";
          };
        };
        mi10lite = {
          arch = "aarch64-linux";
          type = "mobile";
          users.unixpariah = {
            root.enable = true;
            shell = "nushell";
          };
        };
      };

      mkHost =
        hostname: attrs:
        let
          systemUsers = attrs.users;
          system_type = hosts.${hostname}.type;
          std = import ./std { inherit (nixpkgs) lib; };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              hostname
              systemUsers
              system_type
              std
              ;
          };

          modules = [
            ./nixModules
            nix-gaming.nixosModules.pipewireLowLatency
            nix-gaming.nixosModules.platformOptimizations
            disko.nixosModules.default
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            nix-minecraft.nixosModules.minecraft-servers
          ];
        };

      mkDroid =
        hostname: attrs:
        let
          system = hosts.${hostname}.arch;
        in
        nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [ ./hosts/${hostname} ];
        };

      mkHome =
        hostname: username:
        let
          system = hosts.${hostname}.arch;
          pkgs = import nixpkgs { inherit system; };
          shell = "${hosts.${hostname}.users.${username}.shell}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              username
              hostname
              shell
              ;
            system_type = hosts.${hostname}.type;
            std = import ./std { inherit (pkgs) lib; };
          };

          modules = [
            ./homeModules
            stylix.homeModules.stylix
            inputs.nix-index-database.hmModules.nix-index
          ];
        };

      mkNode =
        hostname: attrs:
        let
          system = hosts.${hostname}.arch;
          pkgs = import nixpkgs { inherit system; };
          deployPkgs = import nixpkgs {
            inherit system;
            overlays = [
              deploy-rs.overlay
              (self: super: {
                deploy-rs = {
                  inherit (pkgs) deploy-rs;
                  inherit (super.deploy-rs) lib;
                };
              })
            ];
          };

          hostUsers = hosts.${hostname}.users or { };
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
            |> builtins.listToAttrs;
        in
        {
          inherit hostname;
          profiles = {
            system = {
              user = "root";
              interactiveSudo = true;
              path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.${hostname};
            };
          } // mkUserProfiles hostUsers;
        };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          function pkgs
        );
    in
    with nixpkgs;
    {
      deploy.nodes =
        hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile")
        |> lib.mapAttrs (hostname: attrs: mkNode hostname attrs);
      nixosConfigurations =
        hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile")
        |> lib.mapAttrs (hostname: attrs: mkHost hostname attrs);
      homeConfigurations =
        hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "mobile")
        |> builtins.attrNames
        |> builtins.map (
          host:
          hosts.${host}.users
          |> builtins.attrNames
          |> builtins.map (user: {
            name = "${user}@${host}";
            value = mkHome host user;
          })
        )
        |> builtins.concatLists
        |> builtins.listToAttrs;
      nixOnDroidConfigurations =
        hosts
        |> lib.filterAttrs (_: attrs: attrs.type != "server" && attrs.type != "desktop")
        |> lib.mapAttrs (hostname: attrs: mkDroid hostname attrs);

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
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
    raspberry-pi-nix = {
      url = "github:nix-community/raspberry-pi-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    hyprscroller = {
      url = "github:dawsers/hyprscroller";
      flake = false;
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";

    seto.url = "github:unixpariah/seto";
    moxidle.url = "github:unixpariah/moxidle";
    moxnotify.url = "github:unixpariah/moxnotify";
    moxpaper.url = "github:unixpariah/moxpaper";
    nh = {
      url = "github:unixpariah/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sysnotifier = {
      url = "github:unixpariah/SysNotifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
