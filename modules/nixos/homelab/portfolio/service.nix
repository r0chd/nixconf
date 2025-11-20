{ config, lib, ... }:
{
  config = lib.mkIf config.homelab.portfolio.enable {
    services.k3s.manifests.portfolio-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "portfolio";
          namespace = "portfolio";
        };
        spec = {
          type = "ClusterIP";
          ports = [
            {
              port = 80;
              targetPort = 3000;
            }
          ];
          selector.app = "portfolio";
        };
      }
    ];
  };
}
