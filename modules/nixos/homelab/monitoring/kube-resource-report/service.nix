{ config, lib, ... }:
let
  cfg = config.homelab.kube-resource-report;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.kube-resource-report-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels.application = "kube-resource-report";
          name = "kube-resource-report";
          namespace = "monitoring";
        };
        spec = {
          selector = {
            application = "kube-resource-report";
          };
          type = "ClusterIP";
          ports = [
            {
              name = "kube-resource-report-frontend";
              port = 80;
              protocol = "TCP";
              targetPort = 80;
            }
          ];
        };
      }
    ];
  };
}
