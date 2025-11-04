{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-store-serviceaccount".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
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
      }
    ];
  };
}

