{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."thanos-store-statefulset".content = [
      {
        apiVersion = "apps/v1";
        kind = "StatefulSet";
        metadata = {
          name = "thanos-store";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/component" = "object-store-gateway";
            "app.kubernetes.io/instance" = "thanos-store";
            "app.kubernetes.io/name" = "thanos-store";
            "app.kubernetes.io/version" = "v0.30.2";
          };
        };
        spec = {
          replicas = cfg.store.replicas;
          serviceName = "thanos-store";
          selector.matchLabels = {
            "app.kubernetes.io/component" = "object-store-gateway";
            "app.kubernetes.io/instance" = "thanos-store";
            "app.kubernetes.io/name" = "thanos-store";
          };
          template = {
            metadata.labels = {
              "app.kubernetes.io/component" = "object-store-gateway";
              "app.kubernetes.io/instance" = "thanos-store";
              "app.kubernetes.io/name" = "thanos-store";
              "app.kubernetes.io/version" = "v0.30.2";
            };
            spec = {
              affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution = [
                {
                  podAffinityTerm = {
                    labelSelector.matchExpressions = [
                      {
                        key = "app.kubernetes.io/name";
                        operator = "In";
                        values = [ "thanos-store" ];
                      }
                      {
                        key = "app.kubernetes.io/instance";
                        operator = "In";
                        values = [ "thanos-store" ];
                      }
                    ];
                    namespaces = [ "monitoring" ];
                    topologyKey = "kubernetes.io/hostname";
                  };
                  weight = 100;
                }
              ];
              containers = [
                {
                  name = "thanos-store";
                  inherit (cfg) image;
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "store"
                    "--log.level=info"
                    "--log.format=logfmt"
                    "--data-dir=/var/thanos/store"
                    "--grpc-address=0.0.0.0:10901"
                    "--http-address=0.0.0.0:10902"
                    "--objstore.config=$(OBJSTORE_CONFIG)"
                    "--ignore-deletion-marks-delay=24h"
                  ];
                  env = [
                    {
                      name = "OBJSTORE_CONFIG";
                      valueFrom.secretKeyRef = {
                        key = "thanos.yaml";
                        name = "thanos-objectstorage";
                      };
                    }
                    {
                      name = "HOST_IP_ADDRESS";
                      valueFrom.fieldRef.fieldPath = "status.hostIP";
                    }
                  ];
                  ports = [
                    {
                      containerPort = 10901;
                      name = "grpc";
                    }
                    {
                      containerPort = 10902;
                      name = "http";
                    }
                  ];
                  livenessProbe = {
                    httpGet = {
                      path = "/-/healthy";
                      port = 10902;
                      scheme = "HTTP";
                    };
                    failureThreshold = 8;
                    periodSeconds = 30;
                    timeoutSeconds = 1;
                  };
                  readinessProbe = {
                    httpGet = {
                      path = "/-/ready";
                      port = 10902;
                      scheme = "HTTP";
                    };
                    failureThreshold = 20;
                    periodSeconds = 5;
                  };
                  resources = {
                    limits = {
                      cpu = "0.42";
                      memory = "420Mi";
                    };
                    requests = {
                      cpu = "0.123";
                      memory = "123Mi";
                    };
                  };
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    capabilities.drop = [ "ALL" ];
                    readOnlyRootFilesystem = true;
                    runAsGroup = 65532;
                    runAsNonRoot = true;
                    runAsUser = 65534;
                    seccompProfile = {
                      type = "RuntimeDefault";
                    };
                  };
                  terminationMessagePolicy = "FallbackToLogsOnError";
                  volumeMounts = [
                    {
                      mountPath = "/var/thanos/store";
                      name = "data";
                      readOnly = false;
                    }
                  ];
                }
              ];
              nodeSelector."kubernetes.io/os" = "linux";
              securityContext = {
                fsGroup = 65534;
                runAsGroup = 65532;
                runAsNonRoot = true;
                runAsUser = 65534;
                seccompProfile = {
                  type = "RuntimeDefault";
                };
              };
              serviceAccountName = "thanos-store";
              terminationGracePeriodSeconds = 120;
              volumes = [ ];
            };
          };
          volumeClaimTemplates = [
            {
              metadata = {
                name = "data";
                labels = {
                  "app.kubernetes.io/component" = "object-store-gateway";
                  "app.kubernetes.io/instance" = "thanos-store";
                  "app.kubernetes.io/name" = "thanos-store";
                };
              };
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                resources.requests.storage = cfg.store.storageSize;
              };
            }
          ];
        };
      }
    ];
  };
}
