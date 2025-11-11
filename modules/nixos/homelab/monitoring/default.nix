{ ... }:
{
  imports = [
    ./grafana
    ./prometheus
    ./kube-web
    ./kube-ops
    ./thanos
    ./kube-resource-report
    ./namespace.nix
  ];
}
