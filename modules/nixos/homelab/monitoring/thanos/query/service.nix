{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-query-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "thanos-query";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/component" = "query-layer";
            "app.kubernetes.io/instance" = "thanos-query";
            "app.kubernetes.io/name" = "thanos-query";
            "app.kubernetes.io/version" = "v0.30.2";
          };
        };
        spec = {
          ports = [
            {
              name = "grpc";
              port = 10901;
              targetPort = 10901;
            }
            {
              name = "http";
              port = 9090;
              targetPort = 9090;
            }
          ];
          selector = {
            "app.kubernetes.io/component" = "query-layer";
            "app.kubernetes.io/instance" = "thanos-query";
            "app.kubernetes.io/name" = "thanos-query";
          };
        };
      }
    ];
  };
}

