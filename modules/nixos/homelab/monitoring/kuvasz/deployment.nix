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
              "app.kubernetes.io/name" = "kuvasz";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "kuvasz";
              };
              annotations."reloader.stakater.com/auto" = "true";
            };
            spec = {
              containers = [
                {
                  image = "kuvaszmonitoring/kuvasz:latest";
                  name = "kuvasz";
                  resources = {
                    requests = {
                      memory = "200Mi";
                      cpu = "1024m";
                    };
                    limits = {
                      memory = "512Mi";
                      cpu = "1024m";
                    };
                  };
                  tty = true;
                  ports = [ { containerPort = 8080; } ];
                  startupProbe = {
                    tcpSocket = {
                      port = 8080;
                    };
                    initialDelaySeconds = 10;
                    periodSeconds = 10;
                    timeoutSeconds = 5;
                    failureThreshold = 12;
                    successThreshold = 1;
                  };
                  livenessProbe = {
                    tcpSocket = {
                      port = 8080;
                    };
                    initialDelaySeconds = 60;
                    periodSeconds = 30;
                    timeoutSeconds = 10;
                    failureThreshold = 3;
                    successThreshold = 1;
                  };
                  readinessProbe = {
                    tcpSocket = {
                      port = 8080;
                    };
                    initialDelaySeconds = 45;
                    periodSeconds = 10;
                    timeoutSeconds = 5;
                    failureThreshold = 3;
                    successThreshold = 1;
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
                  volumeMounts = [
                    {
                      name = "config";
                      mountPath = "/config";
                      readOnly = true;
                    }
                  ];
                }
              ];
              volumes = [
                {
                  name = "config";
                  configMap = {
                    name = "kuvasz-config";
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
