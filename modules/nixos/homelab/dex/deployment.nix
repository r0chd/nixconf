{ config, lib, ... }:
let
  cfg = config.homelab.dex;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."dex-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          labels = {
            app = "dex";
          };
          name = "dex";
          namespace = "dex";
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              app = "dex";
            };
          };
          template = {
            metadata = {
              labels = {
                app = "dex";
              };
            };
            spec = {
              serviceAccountName = "dex";
              containers = [
                {
                  image = "ghcr.io/dexidp/dex:v2.32.0";
                  name = "dex";
                  command = [
                    "/usr/local/bin/dex"
                    "serve"
                    "/etc/dex/cfg/config.yaml"
                  ];
                  ports = [
                    {
                      name = "https";
                      containerPort = 5556;
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "config";
                      mountPath = "/etc/dex/cfg";
                    }
                    {
                      name = "tls";
                      mountPath = "/etc/dex/tls";
                    }
                  ];
                  env = [
                    {
                      name = "GITHUB_CLIENT_ID";
                      valueFrom = {
                        secretKeyRef = {
                          name = "github-client";
                          key = "client-id";
                        };
                      };
                    }
                    {
                      name = "GITHUB_CLIENT_SECRET";
                      valueFrom = {
                        secretKeyRef = {
                          name = "github-client";
                          key = "client-secret";
                        };
                      };
                    }
                  ];
                  readinessProbe = {
                    httpGet = {
                      path = "/healthz";
                      port = 5556;
                      scheme = "HTTP";
                    };
                  };
                }
              ];
              volumes = [
                {
                  name = "config";
                  configMap = {
                    name = "dex";
                    items = [
                      {
                        key = "config.yaml";
                        path = "config.yaml";
                      }
                    ];
                  };
                }
                {
                  name = "tls";
                  secret = {
                    secretName = "dex-tls";
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
