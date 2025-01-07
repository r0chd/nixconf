{
  description = "My nixconfig";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    impermanence.url = "github:nix-community/impermanence";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs-unstable";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zls.url = "github:zigtools/zls";
    zig.url = "github:mitchellh/zig-overlay";

    niri.url = "github:sodiboo/niri-flake";
    hyprland.url = "github:hyprwm/Hyprland";

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
      nixpkgs-unstable,
      flake-utils,
      ...
    }@inputs:
    let
      mkHost =
        hostname: attrs:
        let
          pkgs = import nixpkgs-unstable {
            system = attrs.arch;
            config.allowUnfree = true;
          };
        in
        nixpkgs-unstable.lib.nixosSystem {
          inherit pkgs;
          specialArgs = rec {
            inherit
              inputs
              hostname
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
          pkgs = import nixpkgs-unstable {
            system = hosts.${host}.arch;
            config.allowUnfree = true;
          };
          pkgs-stable = import nixpkgs-stable { system = hosts.${host}.arch; };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
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
        server1 = {
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
    with nixpkgs-unstable;
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
