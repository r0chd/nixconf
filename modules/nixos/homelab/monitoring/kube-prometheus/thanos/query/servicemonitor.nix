{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-query-servicemonitor".content = [
      {
        apiVersion = "monitoring.coreos.com/v1";
        kind = "ServiceMonitor";
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
          endpoints = [
            {
              port = "http";
              relabelings = [
                {
                  action = "replace";
                  separator = "/";
                  sourceLabels = [
                    "namespace"
                    "pod"
                  ];
                  targetLabel = "instance";
                }
              ];
            }
          ];
          selector.matchLabels = {
            "app.kubernetes.io/component" = "query-layer";
            "app.kubernetes.io/instance" = "thanos-query";
            "app.kubernetes.io/name" = "thanos-query";
          };
        };
      }
    ];
  };
}
