{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.quickwit;
in
{
  autoDeployCharts.quickwit = lib.mkIf cfg.enable {
    name = "kube-prometheus-stack";
    repo = "https://prometheus-community.github.io/helm-charts";
    version = "79.2.1";
    hash = "sha256-rUZcfcB+O7hrr2swEARXFujN7VvfC0IkaaAeJTi0mN0=";
    targetNamespace = "monitoring";
    values = {
    };
  };
}
