{ config, lib, ... }:
let
  cfg = config.homelab.atuin;
in
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
          inherit (cfg) replicas;
          selector.matchLabels."io.kompose.service" = "atuin";
          template = {
            metadata.labels = {
              "io.kompose.service" = "atuin";
              "app.kubernetes.io/name" = "atuin";
            };
            spec = {
              initContainers = [
                {
                  name = "wait-for-db";
                  image = "postgres:15-alpine";
                  command = [
                    "sh"
                    "-c"
                    "until pg_isready -h atuin-db-rw.atuin.svc.cluster.local -p 5432; do echo 'Waiting for database...'; sleep 2; done"
                  ];
                }
              ];
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

                  inherit (cfg) image;
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
                  inherit (cfg) resources;
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
