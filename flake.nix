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
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = {
      unixpariah = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        modules = [
          ./common/configuration.nix
          ./wayland/configuration.nix
          {
            nixpkgs.system = system;

            specialisation = {
              hyprland = {
                configuration = {imports = [./wayland/hyprland/configuration.nix];};
              };
              sway = {
                configuration = {imports = [./wayland/sway/configuration.nix];};
              };
            };
          }
        ];
      };
    };
  };
}
