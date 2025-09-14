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
    ./nix
  ];

  nixpkgs.overlays = import ../overlays inputs config ++ import ../lib config;
}
