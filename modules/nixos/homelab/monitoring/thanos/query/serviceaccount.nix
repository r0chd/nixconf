{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-query-serviceaccount".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
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
      }
    ];
  };
}

