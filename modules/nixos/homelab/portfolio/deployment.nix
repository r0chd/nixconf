{ config, lib, ... }:
let
  cfg = config.homelab.portfolio;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.portfolio-deployment.content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "portfolio";
          namespace = "portfolio";
          labels = {
            app = "portfolio";
          };
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              app = "portfolio";
            };
          };
          template = {
            metadata = {
              labels = {
                app = "portfolio";
              };
            };
            spec = {
              containers = [
                {
                  name = "portfolio";
                  image = "ghcr.io/r0chd/portfolio:master-3b7094b";
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
