{ lib, ... }:
{
  imports = [
    ./statefulset.nix
    ./service.nix
    ./serviceaccount.nix
    ./servicemonitor.nix
  ];
}


