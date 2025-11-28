{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.kube-web.enable) {
    services.k3s.manifests."kube-web-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";

        metadata = {
          labels."app.kubernetes.io/name" = "kube-web";
          name = "kube-web-view";
          namespace = "monitoring";
        };

        spec = {
          selector = {
            "app.kubernetes.io/name" = "kube-web";
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
