{ config, lib, ... }:
let
  cfg = config.homelab.moxwiki;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."moxwiki-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "moxwiki";
          namespace = "moxwiki";
          labels = {
            "app.kubernetes.io/name" = "moxwiki";
          };
        };
        spec = {
          type = "ClusterIP";
          ports = [
            {
              port = 80;
              targetPort = 3000;
            }
          ];
          selector = {
            "app.kubernetes.io/name" = "moxwiki";
          };
        };
      }
    ];
  };
}
