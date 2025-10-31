{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-server-service".content = [
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        name = "vault";
        namespace = "vault";
        labels = {
          "app.kubernetes.io/name" = "vault";
          "app.kubernetes.io/instance" = "vault";
        };
        annotations."service.alpha.kubernetes.io/tolerate-unready-endpoints" = "true";
      };
      spec = {
        publishNotReadyAddresses = true;
        ports = [
          {
            name = "http";
            port = 8200;
            targetPort = 8200;
          }
          {
            name = "internal";
            port = 8201;
            targetPort = 8201;
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "vault";
          "app.kubernetes.io/instance" = "vault";
          component = "server";
        };
      };
    }
    ];
  };
}
