{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kuvasz;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."kuvasz-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "kuvasz";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "kuvasz";
          };
        };
        spec = {
          selector = {
            matchLabels = {
              app = "kuvasz";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "kuvasz";
                app = "kuvasz";
              };
            };
            spec = {
              containers = [
                {
                  image = "kuvaszmonitoring/kuvasz:latest";
                  name = "kuvasz";
                  resources = {
                    requests = {
                      memory = "154Mi";
                      cpu = "1024m";
                    };
                    limits = {
                      memory = "384Mi";
                      cpu = "1024m";
                    };
                  };
                  tty = true;
                  ports = [ { containerPort = 8080; } ];
                  livenessProbe = {
                    httpGet = {
                      path = "/health";
                      port = 8080;
                    };
                    initialDelaySeconds = 5;
                    periodSeconds = 30;
                  };
                  env = [
                    {
                      name = "DATASOURCES_DEFAULT_URL";
                      valueFrom.secretKeyRef = {
                        name = "kuvasz-db-app";
                        key = "jdbc-uri";
                      };
                    }
                    {
                      name = "DATASOURCES_DEFAULT_USERNAME";
                      valueFrom.secretKeyRef = {
                        name = "kuvasz-db-app";
                        key = "username";
                      };
                    }
                    {
                      name = "DATASOURCES_DEFAULT_PASSWORD";
                      valueFrom.secretKeyRef = {
                        name = "kuvasz-db-app";
                        key = "password";
                      };
                    }

                    # Inject host/port/dbname into the template
                    {
                      name = "DATABASE_HOST";
                      valueFrom.secretKeyRef = {
                        name = "kuvasz-db-app";
                        key = "host";
                      };
                    }
                    {
                      name = "DATABASE_PORT";
                      valueFrom.secretKeyRef = {
                        name = "kuvasz-db-app";
                        key = "port";
                      };
                    }
                    {
                      name = "DATABASE_NAME";
                      valueFrom.secretKeyRef = {
                        name = "kuvasz-db-app";
                        key = "dbname";
                      };
                    }

                    {
                      name = "ENABLE_AUTH";
                      value = "false";
                    }
                  ];
                }
              ];
            };
          };
        };
      }
    ];
  };
}
