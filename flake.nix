{
  description = "My nixconfig";

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      stylix,
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
          {
            _module.args = { inherit inputs; };
          }
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
      devShells =
        let
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
        forAllSystems (pkgs: {
          default = pkgs.mkShell {
            buildInputs = builtins.attrValues {
              inherit (pkgs)
                git
                nixd
                nixfmt
                ;
            };
          };
        });

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
                inherit (config.hosts.${hostName}) system profile platform;
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

      homeConfigurations =
        config.hosts
        |> lib.filterAttrs (_: attrs: attrs.platform != "mobile" && attrs.users != null)
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
    # Necessary
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

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mox-flake.url = "github:mox-desktop/mox-flake";
    whydotool.url = "github:r0chd/whydotool";

    # To be ditched

    # Just copy paste addons from nur-expressions
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake"; # wait for kdl parser to be implemented in nixpkgs
    nh.url = "github:r0chd/nh/notifications"; # Wait for the branch to be merged
  };
}
