{ system, ... }:
{
  imports = [
    ./environment
    ./services
    ./security
    ./programs
    "${inputs.self}/hosts/${config.networking.hostName}"
  ];

  environment.etc = {
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes pipe-operators
      build-users-group = nixbld
    '';
  };

  system.rebuild.enableNg = false;
  nixpkgs.hostPlatform = system;
}
