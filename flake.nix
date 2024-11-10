{
  description = "My nixconfig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

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

    zls.url = "github:zigtools/zls";
    zig.url = "github:mitchellh/zig-overlay";

    hyprland = { url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; };
    niri.url = "github:sodiboo/niri-flake";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";

    # Created by me, myself and I
    seto.url = "github:unixpariah/seto";
    nixvim.url = "github:unixpariah/nixvim";
    waystatus.url = "git+https://github.com/unixpariah/waystatus?submodules=1";
    ruin.url = "git+https://github.com/unixpariah/ruin?submodules=1";
  };

  outputs =
    { nixpkgs-stable, nixpkgs, home-manager, disko, flake-utils, ... }@inputs:
    let
      newConfig = username: hostname: arch:
        let
          pkgs = import nixpkgs {
            system = arch;
            config.allowUnfree = true;
          };
          pkgs-stable = import nixpkgs-stable {
            system = arch;
            config.allowUnfree = true;
          };
        in nixpkgs.lib.nixosSystem {
          specialArgs = rec {
            inherit inputs hostname arch pkgs pkgs-stable username;
            std = import ./std {
              inherit hostname username;
              lib = pkgs.lib;
            };
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.default
            disko.nixosModules.default
            ./nixModules
          ];
        };
    in {
      nixosConfigurations = {
        laptop = newConfig "unixpariah" "laptop" "x86_64-linux";
      };

      devShells = flake-utils.lib.eachDefaultSystem (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          zig = import ./shells/zig.nix { inherit pkgs inputs; };
          c = import ./shells/c.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
        });
    };
}
