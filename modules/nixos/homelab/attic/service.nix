{ lib, config, ... }:
let
  cfg = config.homelab.attic;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."attic-deployment".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "attic-server";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
        };
        spec = {
          selector = {
            "app.kubernetes.io/name" = "attic-server";
          };
          ports = [
            {
              name = "http";
              port = 8080;
              targetPort = "http";
            }
          ];
        };
      }
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "attic-server";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
        };
        spec = {
          selector = {
            matchLabels = {
              "app.kubernetes.io/name" = "attic-server";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "attic-server";
              };
            };
            spec = {
              volumes = [
                {
                  name = "store";
                  persistentVolumeClaim = {
                    claimName = "attic-store";
                  };
                }
                {
                  name = "config";
                  configMap = {
                    name = "attic-config";
                  };
                }
              ];
              containers = [
                {
                  name = "attic-server";
                  image = "ghcr.io/zhaofengli/attic";
                  args = [ "--config=/etc/attic/config.toml" ];
                  env = [
                    {
                      name = "RUST_LOG";
                      value = "INFO,sqlx::query=warn";
                    }
                  ];
                  envFrom = [
                    {
                      secretRef = {
                        name = "attic-server-env";
                      };
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "store";
                      mountPath = "/srv/store/";
                    }
                    {
                      name = "config";
                      mountPath = "/etc/attic/";
                    }
                  ];
                  ports = [
                    {
                      name = "http";
                      containerPort = 8080;
                    }
                  ];
                  readinessProbe = {
                    httpGet = {
                      port = "http";
                      httpHeaders = [
                        {
                          name = "Host";
                          value = "babe-do-you-need-anything-from-the-nix.store";
                        }
                      ];
                    };
                  };
                  resources = {
                    requests = {
                      cpu = "10m";
                    };
                    limits = {
                      memory = "1Gi";
                    };
                  };
                }
              ];
            };
          };
        };
      }
      {
        apiVersion = "v1";
        kind = "PersistentVolumeClaim";
        metadata = {
          name = "attic-store";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
        };
        spec = {
          storageClassName = "local-path";
          accessModes = [ "ReadWriteMany" ];
          resources = {
            requests = {
              storage = "50G";
            };
          };
        };
      }
    ];
  };
}
