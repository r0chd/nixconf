{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-store-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "thanos-store";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/component" = "object-store-gateway";
            "app.kubernetes.io/instance" = "thanos-store";
            "app.kubernetes.io/name" = "thanos-store";
            "app.kubernetes.io/version" = "v0.30.2";
          };
        };
        spec = {
          clusterIP = "None";
          ports = [
            {
              name = "grpc";
              port = 10901;
              targetPort = 10901;
            }
            {
              name = "http";
              port = 10902;
              targetPort = 10902;
            }
          ];
          selector = {
            "app.kubernetes.io/component" = "object-store-gateway";
            "app.kubernetes.io/instance" = "thanos-store";
            "app.kubernetes.io/name" = "thanos-store";
          };
        };
      }
    ];
  };
}
