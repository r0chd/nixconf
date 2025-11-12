{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.vector.enable) {
    services.k3s.manifests."vector-serviceaccount".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "vector";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
            "app.kubernetes.io/version" = "0.51.0-distroless-libc";
          };
        };
        automountServiceAccountToken = true;
      }
    ];
  };
}
