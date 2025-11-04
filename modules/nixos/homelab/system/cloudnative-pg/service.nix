{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.system.cloudnative-pg.enable) {
    services.k3s.manifests.cnpg-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "cnpg-webhook-service";
          namespace = "system";
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
