{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.kube-web.enable) {
    services.k3s.manifests."kube-web-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";

        metadata = {
          labels.application = "kube-web-view";
          name = "kube-web-view";
          namespace = "monitoring";
        };

        spec = {
          selector = {
            application = "kube-web-view";
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
