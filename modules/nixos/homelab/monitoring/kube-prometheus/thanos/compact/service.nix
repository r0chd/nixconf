{ config, lib, ... }:
{
  config = lib.mkIf config.homelab.monitoring.thanos.enable {
    services.k3s.manifests."thanos-compact-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "thanos-compact";
            "app.kubernetes.io/component" = "compact";
            "app.kubernetes.io/part-of" = "thanos";
          };
          name = "thanos-compact";
          namespace = "monitoring";
          annotations = {
            "prometheus.io/path" = "/metrics";
            "prometheus.io/port" = "10902";
            "prometheus.io/scrape" = "true";
          };
        };
        spec = {
          ports = [
            {
              port = 10902;
              protocol = "TCP";
              targetPort = "http";
              name = "http-query";
            }
          ];
          selector = {
            "app.kubernetes.io/name" = "thanos-compact";
          };
          sessionAffinity = "None";
        };
      }
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "thanos-compact";
          namespace = "monitoring";
        };
      }
    ];
  };
}
