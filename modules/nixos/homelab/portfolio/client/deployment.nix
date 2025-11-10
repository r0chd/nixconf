{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.portfolio.enable) {
    services.k3s.manifests."portfolio-client-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "portfolio-client";
          namespace = "portfolio";
          labels = {
            app = "portfolio-client";
          };
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              app = "portfolio-client";
            };
          };
          template = {
            metadata = {
              labels = {
                app = "portfolio-client";
              };
            };
            spec = {
              containers = [
                {
                  name = "portfolio-client";
                  env = [
                    {
                      name = "HOST";
                      value = "0.0.0.0";
                    }
                  ];
                  image = "ghcr.io/r0chd/portfolio-client:main-a05f342";
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
