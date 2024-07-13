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
    disko.url = "github:nix-community/disko";

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
    newConfig = hostname: arch:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs hostname;};
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
      laptop = newConfig "laptop" "x86_64-linux";
      server1 = newConfig "server1" "x86_64-linux";
      server2 = newConfig "server2" "x86_64-linux";
    };
  };
}
