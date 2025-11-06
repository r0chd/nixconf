{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.thanos.enable) {
    services.k3s.manifests."thanos-query-frontend-serviceaccount".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
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
      }
    ];
  };
}
