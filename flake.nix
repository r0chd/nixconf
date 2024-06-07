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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-conf.url = "github:unixpariah/neovim";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          inputs.disko.nixosModules.default
          ./hosts/unixpariah/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.impermanence.nixosModules.impermanence
          {
            nixpkgs.system = "x86_64-linux";
          }
        ];
      };
    };
  };
}
