{ ... }:
{
  imports = [
    ./ingressclass.nix
    ./configmap.nix
    ./rbac.nix
    ./deployment.nix
    ./service.nix
    ./admission-webhooks
  ];
}
