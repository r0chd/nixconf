{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.portfolio.enable) {
    services.k3s.manifests."portfolio-server-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "portfolio-client";
          namespace = "portfolio";
        };
        spec = {
          type = "ClusterIP";
          ports = [
            {
              protocol = "TCP";
              port = 80;
              targetPort = 3000;
            }
          ];
          selector = {
            app = "portfolio-client";
          };
        };
      }
    ];
  };
}
