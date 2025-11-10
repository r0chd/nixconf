{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.portfolio.enable) {
    services.k3s.manifests."portfolio-server-service" = {
      content = [
        {
          apiVersion = "v1";
          kind = "Service";
          metadata = {
            labels."io.kompose.service" = "portfolio-server";
            name = "portfolio-server";
            namespace = "portfolio";
          };
          spec = {
            type = "NodePort";
            ports = [
              {
                name = "http";
                port = 8888;
                targetPort = 8888;
              }
            ];
            selector."io.kompose.service" = "portfolio-server";
          };
        }
      ];
    };
  };
}
