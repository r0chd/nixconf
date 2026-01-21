{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.headlamp;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."headlamp-service".content = [
      {
        kind = "Service";
        apiVersion = "v1";
        metadata = {
          name = "headlamp";
          namespace = "monitoring";
        };
        spec = {
          ports = [
            {
              port = 80;
              targetPort = 4466;
            }
          ];
          selector = {
            k8s-app = "headlamp";
          };
        };
      }
    ];
  };
}
