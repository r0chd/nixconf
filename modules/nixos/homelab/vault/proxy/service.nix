{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable && config.homelab.vault.proxy.enable) {
    services.k3s.manifests."vault-proxy-service".content = [
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        name = "vault-proxy";
        namespace = "vault";
        labels = {
          "app.kubernetes.io/name" = "vault-proxy";
          "app.kubernetes.io/instance" = "vault";
        };
      };
      spec = {
        ports = [
          {
            name = "http";
            port = 8200;
            targetPort = 8200;
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "vault-proxy";
          "app.kubernetes.io/instance" = "vault";
          component = "proxy";
        };
      };
    }
    ];
  };
}


