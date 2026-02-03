{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."thanos-compact-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "thanos-compact";
          namespace = "monitoring";
        };
        spec = {
          strategy = {
            type = "Recreate";
          };
          replicas = 1;
          selector = {
            matchLabels = {
              "app.kubernetes.io/name" = "thanos-compact";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "thanos-compact";
                "app.kubernetes.io/component" = "compact";
                "app.kubernetes.io/part-of" = "thanos";
              };
              name = "thanos-compact";
              annotations."reloader.stakater.com/auto" = "true";
            };
            spec = {
              terminationGracePeriodSeconds = 1200;
              serviceAccountName = "thanos-compact";
              containers = [
                {
                  name = "thanos-compact";
                  inherit (cfg) image;
                  args = [
                    "compact"
                    "--block-viewer.global.sync-block-interval=1h"
                    "--compact.skip-block-with-out-of-order-chunks"
                    "--data-dir=/var/thanos/compact"
                    "--delete-delay=48h"
                    "--log.level=warn"
                    "--objstore.config-file=/etc/thanos/config.yaml"
                    "--retention.resolution-1h=1y"
                    "--retention.resolution-5m=1y"
                    "--retention.resolution-raw=1y"
                    "--wait"
                    "--wait-interval=1h"
                  ];
                  ports = [
                    {
                      name = "http";
                      containerPort = 10902;
                    }
                  ];
                  livenessProbe = {
                    httpGet = {
                      path = "/-/healthy";
                      port = "http";
                      scheme = "HTTP";
                    };
                    periodSeconds = 90;
                    successThreshold = 1;
                    failureThreshold = 5;
                    timeoutSeconds = 10;
                  };
                  readinessProbe = {
                    httpGet = {
                      path = "/-/ready";
                      port = "http";
                      scheme = "HTTP";
                    };
                    periodSeconds = 90;
                    successThreshold = 1;
                    failureThreshold = 5;
                    timeoutSeconds = 10;
                  };
                  volumeMounts = [
                    {
                      name = "data";
                      mountPath = "/var/thanos/compact";
                    }
                    {
                      name = "thanos-storage";
                      mountPath = "/etc/thanos";
                    }
                  ];
                  resources = cfg.compact.resources;
                }
              ];
              securityContext = {
                fsGroup = 1001;
              };
              volumes = [
                {
                  name = "data";
                  persistentVolumeClaim = {
                    claimName = "thanos-compact";
                  };
                }
                {
                  name = "thanos-storage";
                  secret = {
                    secretName = "thanos-objectstorage";
                    items = [
                      {
                        key = "thanos.yaml";
                        path = "config.yaml";
                      }
                    ];
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
