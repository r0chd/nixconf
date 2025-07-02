{
  config,
  lib,
  pkgs,
  hostName,
  inputs,
  ...
}:
{
  imports = [
    ../nixModules/virtualization
    ./environment
    ./services
    ./security
    ./programs
    #./users
    ../hosts/${hostName}
  ];

  environment.etc = {
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes pipe-operators
      build-users-group = nixbld
    '';
  };
}
