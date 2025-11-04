{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-query-frontend-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "thanos-query-frontend";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/component" = "query-cache";
            "app.kubernetes.io/instance" = "thanos-query-frontend";
            "app.kubernetes.io/name" = "thanos-query-frontend";
            "app.kubernetes.io/version" = "v0.30.2";
          };
        };
        spec = {
          ports = [
            {
              name = "http";
              port = 9090;
              targetPort = 9090;
            }
          ];
          selector = {
            "app.kubernetes.io/component" = "query-cache";
            "app.kubernetes.io/instance" = "thanos-query-frontend";
            "app.kubernetes.io/name" = "thanos-query-frontend";
          };
        };
      }
    ];
  };
}

