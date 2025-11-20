{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.vault-ui-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "vault-ui";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault-ui";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        spec = {
          selector = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
            component = "server";
          };
          publishNotReadyAddresses = true;
          ports = [
            {
              name = "http";
              port = 8200;
              targetPort = 8200;
            }
          ];
          type = "ClusterIP";
        };
      }
    ];
  };
}
