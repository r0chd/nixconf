{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.cloudnative-pg.enable) {
    services.k3s.manifests.cnpg-namespace.content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "system";
          labels."app.kubernetes.io/name" = "cloudnative-pg";
        };
      }
    ];
  };
}
