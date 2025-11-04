{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.cloudnative-pg.enable) {
    services.k3s.manifests.cnpg-serviceaccount.content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "cnpg-manager";
          namespace = "system";
        };
      }
    ];
  };
}
