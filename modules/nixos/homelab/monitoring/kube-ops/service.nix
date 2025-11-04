{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.kube-ops;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."kube-ops-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";

        metadata = {
          labels.application = "kube-ops";
          name = "kube-ops";
          namespace = "monitoring";
        };

        spec = {
          selector = {
            application = "kube-ops";
          };
          type = "ClusterIP";
          ports = [
            {
              port = 80;
              protocol = "TCP";
              targetPort = 8080;
            }
          ];
        };
      }
    ];
  };
}
