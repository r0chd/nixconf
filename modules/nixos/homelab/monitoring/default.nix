{ ... }:
{
  imports = [
    ./kube-web
    ./kube-ops
    ./thanos
    ./kube-resource-report
    ./namespace.nix
    ./kube-prometheus
  ];
}
