{ ... }:
{
  imports = [
    ./serviceaccount.nix
    ./service.nix
    ./config-configmap.nix
    ./disruptionbudget.nix
    ./clusterrolebinding.nix
    ./pvc.nix
    ./statefulset.nix
    ./ingress.nix
  ];
}
