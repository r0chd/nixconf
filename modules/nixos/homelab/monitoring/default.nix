{ ... }:
{
  imports = [
    ./grafana
    ./prometheus
    ./kube-web
    ./kube-ops
    ./thanos
  ];
}
