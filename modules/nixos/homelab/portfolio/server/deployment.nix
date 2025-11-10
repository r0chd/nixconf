{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.portfolio.enable) {
    services.k3s.manifests."portfolio-deployment-service" = {
      content = [
        {
          apiVersion = "apps/v1";
          kind = "Deployment";
          metadata = {
            name = "portfolio-server";
            namespace = "portfolio";
            labels = {
              app = "portfolio-server";
            };
          };
          spec = {
            replicas = 1;
            selector = {
              matchLabels = {
                app = "portfolio-server";
              };
            };
            template = {
              metadata = {
                labels = {
                  app = "portfolio-server";
                };
              };
              spec = {
                containers = [
                  {
                    name = "portfolio-server";
                    env = [
                      {
                        name = "DATABASE_URL";
                        valueFrom.secretKeyRef = {
                          name = "portfolio-db-app";
                          key = "uri";
                        };
                      }
                    ];
                    image = "ghcr.io/r0chd/portfolio-server:latest";
                    ports = [ { containerPort = 8000; } ];
                    resources = {
                      limits = {
                        memory = "100Mi";
                      };
                    };
                    volumeMounts = [
                      {
                        name = "github-secret";
                        mountPath = "/run/secrets/github_api";
                        subPath = "github_api";
                        readOnly = true;
                      }
                    ];
                  }
                ];
                volumes = [
                  {
                    name = "github-secret";
                    secret = {
                      secretName = "github-api";
                    };
                  }
                ];
              };
            };
          };
        }
      ];
    };
  };
}
