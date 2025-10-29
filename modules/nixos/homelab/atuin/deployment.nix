{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) {
    services.k3s.manifests."atuin-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "atuin";
          namespace = "atuin";
        };
        spec = {
          replicas = 1;
          selector.matchLabels."io.kompose.service" = "atuin";
          template = {
            metadata.labels = {
              "io.kompose.service" = "atuin";
              "app.kubernetes.io/name" = "atuin";
            };
            spec = {
              containers = [
                {
                  args = [
                    "server"
                    "start"
                  ];

                  env = [
                    {
                      name = "ATUIN_DB_URI";
                      valueFrom.secretKeyRef = {
                        name = "atuin-db-app";
                        key = "uri";
                      };
                    }
                    {
                      name = "ATUIN_PORT";
                      value = "8888";
                    }
                    {
                      name = "ATUIN_HOST";
                      value = "0.0.0.0";
                    }
                    {
                      name = "ATUIN_OPEN_REGISTRATION";
                      value = "true";
                    }
                  ];

                  image = "ghcr.io/atuinsh/atuin:latest";
                  name = "atuin";
                  ports = [ { containerPort = 8888; } ];
                  readinessProbe = {
                    httpGet = {
                      path = "/";
                      port = 8888;
                    };
                    initialDelaySeconds = 10;
                    periodSeconds = 5;
                    timeoutSeconds = 3;
                    failureThreshold = 3;
                  };
                  livenessProbe = {
                    httpGet = {
                      path = "/";
                      port = 8888;
                    };
                    initialDelaySeconds = 30;
                    periodSeconds = 10;
                    timeoutSeconds = 5;
                    failureThreshold = 3;
                  };
                  resources = {
                    limits = {
                      cpu = "250m";
                      memory = "1Gi";
                    };
                    requests = {
                      cpu = "250m";
                      memory = "1Gi";
                    };
                  };
                  volumeMounts = [
                    {
                      mountPath = "/config";
                      name = "atuin-claim0";
                    }
                  ];
                }
              ];
              volumes = [
                {
                  name = "atuin-claim0";
                  persistentVolumeClaim.claimName = "atuin-claim0";
                }
              ];
            };
          };
        };
      }
    ];
  };
}
