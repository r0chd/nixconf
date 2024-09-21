{
  description = "My nixconfig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
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
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    seto.url = "github:unixpariah/seto";
    waystatus.url = "git+https://github.com/unixpariah/waystatus?submodules=1";
    ruin.url = "git+https://github.com/unixpariah/ruin?submodules=1";
    zls.url = "github:zigtools/zls";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    nixpkgs,
    home-manager,
    disko,
    flake-utils,
    zls,
    zig,
    ...
  } @ inputs: let
    newConfig = hostname: arch:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs hostname arch;};
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.default
          disko.nixosModules.default
          {
            nixpkgs.system = arch;
          }
        ];
      };
  in {
    nixosConfigurations = {
      laptop = newConfig "laptop" "x86_64-linux";
    };

    devShells = flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        zig = import ./shells/zig.nix {inherit pkgs system zls zig;};
        c = import ./shells/c.nix {inherit pkgs;};
        rust = import ./shells/rust.nix {inherit pkgs;};
      }
    );
  };
}
