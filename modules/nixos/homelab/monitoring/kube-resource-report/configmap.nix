{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kube-resource-report;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.kube-resource-report-configmap.content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "kube-resource-report";
          namespace = "monitoring";
        };
        data = {
          "pricing.csv" = "dc-1,master,30.000\ndc-1,worker,500.000";
        };
      }
    ];
  };
}
