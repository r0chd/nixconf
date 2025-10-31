{ ... }:
{
  imports = [
    ./serviceaccount.nix
    ./service.nix
    ./config-configmap.nix
    ./disruptionbudget.nix
    ./clusterrolebinding.nix
    ./statefulset.nix
    ./ingress.nix
  ];
}
