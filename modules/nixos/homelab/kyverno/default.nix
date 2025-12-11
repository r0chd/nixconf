{ ... }:
{
  imports = [
    ./deployment.nix
    ./rbac.nix
    ./namespace.nix
    ./configmap.nix
    ./service.nix
    ./crd.nix
    ./policies
  ];
}
