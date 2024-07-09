{
  description = "My nixconfig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    seto.url = "github:unixpariah/seto";
    waystatus.url = "git+https://github.com/unixpariah/waystatus?submodules=1";
    ruin.url = "git+https://github.com/unixpariah/ruin?submodules=1";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    config = hostname: arch:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.default
          {
            nixpkgs.system = arch;
          }
        ];
      };
  in {
    nixosConfigurations = {
      laptop = config "laptop" "x86_64-linux";
    };
  };
}
