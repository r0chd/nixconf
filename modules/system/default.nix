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
    ./nix
  ];

  nixpkgs.overlays = import ../overlays inputs config ++ import ../lib config;
}
