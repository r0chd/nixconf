{
  inputs,
  config,
  ...
}:
{
  imports = [
    ./environment
    ./services
    ./security
    ./programs
  ];

  environment.etc = {
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes pipe-operator pipe-operator
      experimental-features = nix-command flakes pipe-operator
      build-users-group = nixbld
      accept-flake-config = true
      trusted-users = root @wheel
    '';
  };

  nixpkgs.overlays = import ../overlays inputs config ++ import ../lib config;
}
