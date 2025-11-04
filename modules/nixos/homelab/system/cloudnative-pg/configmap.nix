{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.cloudnative-pg.enable) {
    services.k3s.manifests.cnpg-configmap.content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "cnpg-default-monitoring";
          namespace = "system";
          labels."cnpg.io/reload" = "";
        };
        data.queries = builtins.readFile ./monitoring-queries.yaml;
      }
    ];
  };
}
