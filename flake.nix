{
  description = "My nixconfig";

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      stylix,
      lix-module,
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
            std = import ./std { inherit (nixpkgs) lib; };
          };
          modules = [
            ./nixModules
            disko.nixosModules.default
            stylix.nixosModules.stylix
            lix-module.nixosModules.default
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
            std = import ./std { inherit (pkgs) lib; };
          };

          modules = [
            ./homeModules
            stylix.homeManagerModules.stylix
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

      devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.nixd
            ];
          };
        }
      );
    };

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";

    seto = {
      url = "github:unixpariah/seto";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:unixpariah/nixvim";
    ruin = {
      url = "git+https://github.com/unixpariah/ruin?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    moxidle = {
      url = "github:unixpariah/moxidle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    moxnotify = {
      url = "git+ssh://git@github.com/unixpariah/moxnotify.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
