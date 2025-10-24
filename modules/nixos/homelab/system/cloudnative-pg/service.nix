{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.cloudnative-pg.enable) {
    services.k3s.manifests.cnpg-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "cnpg-webhook-service";
          namespace = "cnpg-system";
        };
        spec = {
          ports = [
            {
              port = 443;
              targetPort = 9443;
            }
          ];
          selector."app.kubernetes.io/name" = "cloudnative-pg";
        };
      }
    ];
  };
}

