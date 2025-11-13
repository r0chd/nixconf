{ ... }:
{
  imports = [
    ./kube-web
    ./kube-ops
    ./kube-resource-report
    ./namespace.nix
    ./kube-prometheus
    ./vector
    ./quickwit
  ];
}
