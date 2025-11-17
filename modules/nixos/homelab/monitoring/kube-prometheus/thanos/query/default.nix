{ lib, ... }:
{
  imports = [
    ./deployment.nix
    ./service.nix
    ./serviceaccount.nix
    ./servicemonitor.nix
  ];
}
