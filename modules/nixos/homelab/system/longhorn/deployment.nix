{ lib, config, ... }:
let
  cfg = config.homelab.system.longhorn;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.longhorn-deployment.content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "longhorn-driver-deployer";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              app = "longhorn-driver-deployer";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                app = "longhorn-driver-deployer";
              };
              annotations."reloader.stakater.com/auto" = "true";
            };
            spec = {
              initContainers = [
                {
                  name = "wait-longhorn-manager";
                  image = "longhornio/longhorn-manager:v1.10.1";
                  command = [
                    "sh"
                    "-c"
                    "while [ $(curl -m 1 -s -o /dev/null -w \"%{http_code}\" http://longhorn-backend:9500/v1) != \"200\" ]; do echo waiting; sleep 2; done"
                  ];
                }
              ];
              containers = [
                {
                  name = "longhorn-driver-deployer";
                  image = "longhornio/longhorn-manager:v1.10.1";
                  imagePullPolicy = "IfNotPresent";
                  command = [
                    "longhorn-manager"
                    "-d"
                    "deploy-driver"
                    "--manager-image"
                    "longhornio/longhorn-manager:v1.10.1"
                    "--manager-url"
                    "http://longhorn-backend:9500/v1"
                  ];
                  env = [
                    {
                      name = "POD_NAMESPACE";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.namespace";
                        };
                      };
                    }
                    {
                      name = "NODE_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "spec.nodeName";
                        };
                      };
                    }
                    {
                      name = "SERVICE_ACCOUNT";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "spec.serviceAccountName";
                        };
                      };
                    }
                    {
                      name = "CSI_ATTACHER_IMAGE";
                      value = "longhornio/csi-attacher:v4.10.0-20251030";
                    }
                    {
                      name = "CSI_PROVISIONER_IMAGE";
                      value = "longhornio/csi-provisioner:v5.3.0-20251030";
                    }
                    {
                      name = "CSI_NODE_DRIVER_REGISTRAR_IMAGE";
                      value = "longhornio/csi-node-driver-registrar:v2.15.0-20251030";
                    }
                    {
                      name = "CSI_RESIZER_IMAGE";
                      value = "longhornio/csi-resizer:v1.14.0-20251030";
                    }
                    {
                      name = "CSI_SNAPSHOTTER_IMAGE";
                      value = "longhornio/csi-snapshotter:v8.4.0-20251030";
                    }
                    {
                      name = "CSI_LIVENESS_PROBE_IMAGE";
                      value = "longhornio/livenessprobe:v2.17.0-20251030";
                    }
                  ];
                }
              ];
              priorityClassName = "longhorn-critical";
              serviceAccountName = "longhorn-service-account";
              securityContext = {
                runAsUser = 0;
              };
            };
          };
        };
      }
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            app = "longhorn-ui";
          };
          name = "longhorn-ui";
          namespace = "system";
        };
        spec = {
          replicas = 2;
          selector = {
            matchLabels = {
              app = "longhorn-ui";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                app = "longhorn-ui";
              };
              annotations."reloader.stakater.com/auto" = "true";
            };
            spec = {
              serviceAccountName = "longhorn-ui-service-account";
              affinity = {
                podAntiAffinity = {
                  preferredDuringSchedulingIgnoredDuringExecution = [
                    {
                      podAffinityTerm = {
                        labelSelector = {
                          matchExpressions = [
                            {
                              key = "app";
                              operator = "In";
                              values = [ "longhorn-ui" ];
                            }
                          ];
                        };
                        topologyKey = "kubernetes.io/hostname";
                      };
                      weight = 1;
                    }
                  ];
                };
              };
              containers = [
                {
                  name = "longhorn-ui";
                  image = "longhornio/longhorn-ui:v1.10.1";
                  imagePullPolicy = "IfNotPresent";
                  volumeMounts = [
                    {
                      name = "nginx-cache";
                      mountPath = "/var/cache/nginx/";
                    }
                    {
                      name = "nginx-config";
                      mountPath = "/var/config/nginx/";
                    }
                    {
                      name = "var-run";
                      mountPath = "/var/run/";
                    }
                  ];
                  ports = [
                    {
                      containerPort = 8000;
                      name = "http";
                    }
                  ];
                  env = [
                    {
                      name = "LONGHORN_MANAGER_IP";
                      value = "http://longhorn-backend:9500";
                    }
                    {
                      name = "LONGHORN_UI_PORT";
                      value = "8000";
                    }
                  ];
                }
              ];
              volumes = [
                {
                  emptyDir = { };
                  name = "nginx-cache";
                }
                {
                  emptyDir = { };
                  name = "nginx-config";
                }
                {
                  emptyDir = { };
                  name = "var-run";
                }
              ];
              priorityClassName = "longhorn-critical";
            };
          };
        };
      }
    ];
  };
}
