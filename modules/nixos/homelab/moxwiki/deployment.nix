{ config, lib, ... }:
let
  cfg = config.homelab.moxwiki;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."thanos-query-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "moxwiki";
          namespace = "moxwiki";
          labels = {
            app = "moxwiki";
          };
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              app = "moxwiki";
            };
          };
          template = {
            metadata = {
              labels = {
                app = "moxwiki";
              };
            };
            spec = {
              containers = [
                {
                  name = "moxwiki";
                  image = "ghcr.io/mox-desktop/moxwiki:latest";
                  ports = [ { containerPort = 3000; } ];
                  resources = {
                    limits = {
                      memory = "512Mi";
                    };
                  };
                }
              ];
            };
          };
        };
      }
    ];
  };
}
