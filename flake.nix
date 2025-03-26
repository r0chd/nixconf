{
  description = "My nixconfig";

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      hosts = {
        laptop = {
          arch = "x86_64-linux";
          type = "desktop";
          users.unixpariah = {
            root.enable = true;
            shell = "nushell";
          };
        };
        rpi = {
          arch = "aarch64-linux";
          type = "server";
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
            disko.nixosModules.default
            stylix.nixosModules.stylix
          ];

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
            stylix.homeManagerModules.stylix
          ];
        };
    in
    with nixpkgs;
    {
      nixosConfigurations = hosts |> lib.mapAttrs (hostname: attrs: mkHost hostname attrs);
      homeConfigurations =
        builtins.attrNames hosts
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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    seto = {
      url = "github:unixpariah/seto";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ruin = {
      url = "git+https://github.com/unixpariah/ruin?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    moxidle = {
      url = "github:unixpariah/moxidle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    moxnotify = {
      url = "github:unixpariah/moxnotify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    moxctl = {
      url = "github:unixpariah/moxctl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
