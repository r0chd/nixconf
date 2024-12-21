{
  description = "My nixconfig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixfmt.url = "github:NixOS/nixfmt";

    stylix.url = "github:danth/stylix";

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
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls.url = "github:zigtools/zls";
    zig.url = "github:mitchellh/zig-overlay";

    niri.url = "github:sodiboo/niri-flake";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Created by me, myself and I
    seto.url = "github:unixpariah/seto";
    nixvim.url = "github:unixpariah/nixvim";
    waystatus.url = "git+https://github.com/unixpariah/waystatus?submodules=1";
    ruin.url = "git+https://github.com/unixpariah/ruin?submodules=1";
  };

  outputs =
    {
      nixpkgs-stable,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      mkHost =
        hostname: attrs:
        let
          pkgs = import nixpkgs {
            system = attrs.arch;
            config.allowUnfree = true;
          };
          pkgs-stable = import nixpkgs-stable {
            system = attrs.arch;
            config.allowUnfree = true;
          };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = rec {
            inherit
              inputs
              hostname
              pkgs
              pkgs-stable
              ;
            systemUsers = attrs.users;
            std = import ./std {
              inherit hostname;
              lib = pkgs.lib;
            };
          };
          modules = [
            ./nixModules
            inputs.disko.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };

      mkHome =
        host: user:
        let
          pkgs = import nixpkgs {
            system = hosts.${host}.arch;
            config.allowUnfree = true;
          };
          pkgs-stable = import nixpkgs-stable {
            system = hosts.${host}.arch;
            config.allowUnfree = true;
          };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              pkgs
              pkgs-stable
              ;
            std = import ./std {
              hostname = "${host}";
              lib = pkgs.lib;
            };
            shell = "${hosts.${host}.users.${user}.shell}";
            username = "${user}";
            host = "${host}";
          };

          modules = [
            ./homeModules
            inputs.stylix.homeManagerModules.stylix
          ];
        };

      hosts = {
        laptop = {
          arch = "x86_64-linux";
          users = {
            unixpariah = {
              root.enable = true;
              shell = "zsh";
            };
          };
        };
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

      devShells = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          zig = import ./shells/zig.nix { inherit pkgs inputs; };
          c = import ./shells/c.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
        }
      );
    };
}
