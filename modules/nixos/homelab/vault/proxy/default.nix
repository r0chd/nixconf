{ ... }:
{
  imports = [
    ./serviceaccount.nix
    ./service.nix
    ./config-configmap.nix
    ./deployment.nix
  ];
}


