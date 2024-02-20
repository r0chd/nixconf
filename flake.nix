{
  description = "My nixconfig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };

  in 
  {
    nixosConfigurations = {
      nixconf = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

      homeConfigurations."unixpariah" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./nixos/home.nix ];
      };
  };
}
