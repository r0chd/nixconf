{ ... }:
{
  imports = [
    ./kube-web
    ./kube-ops
    ./namespace.nix
    ./kube-prometheus
    ./vector
    ./quickwit
    ./kuvasz
  ];
}
