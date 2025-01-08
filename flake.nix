{
  description = "My nixconfig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls.url = "github:zigtools/zls";
    zig.url = "github:mitchellh/zig-overlay";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Created by me, myself and I
    seto = {
      url = "github:unixpariah/seto";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:unixpariah/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waystatus = {
      url = "git+https://github.com/unixpariah/waystatus?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ruin = {
      url = "git+https://github.com/unixpariah/ruin?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      mkHost =
        hostname: attrs:
        let
          systemUsers = attrs.users;
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              hostname
              systemUsers
              ;
            std = import ./std { lib = nixpkgs.lib; };
          };
          modules = [
            ./nixModules
            inputs.disko.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];

        };

      mkHome =
        hostname: username:
        let
          system = hosts.${hostname}.arch;
          pkgs = import nixpkgs { inherit system; };
          shell = "${hosts.${hostname}.users.${username}.shell}";
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              username
              hostname
              shell
              ;
            std = import ./std { lib = pkgs.lib; };
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
