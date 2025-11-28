{ config, lib, ... }:
let
  cfg = config.homelab.moxwiki;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."moxwiki-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "moxwiki";
          namespace = "moxwiki";
          labels = {
            "app.kubernetes.io/name" = "moxwiki";
          };
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              "app.kubernetes.io/name" = "moxwiki";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "moxwiki";
              };
              annotations."reloader.stakater.com/auto" = "true";
            };
            spec = {
              containers = [
                {
                  name = "moxwiki";
                  image = "ghcr.io/mox-desktop/moxwiki:latest";
                  imagePullPolicy = "Always";
                  ports = [ { containerPort = 3000; } ];
                  inherit (cfg) resources;
                }
              ];
            };
          };
        };
      }
    ];
  };
}
