{ system, ... }:
{
  imports = [
    ./environment
    ./services
    ./security
    ./programs
    ../../hosts/${config.networking.hostName}
  ];

  environment.etc = {
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes pipe-operators
      build-users-group = nixbld
    '';
  };

  nixpkgs.hostPlatform = system;
}
