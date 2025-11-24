{ lib, config, ... }:
let
  cfg = config.homelab.system.longhorn;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.longhorn-daemonset.content = [
      {
        apiVersion = "apps/v1";
        kind = "DaemonSet";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            app = "longhorn-manager";
          };
          name = "longhorn-manager";
          namespace = "system";
        };
        spec = {
          selector = {
            matchLabels = {
              app = "longhorn-manager";
            };
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
                app = "longhorn-manager";
              };
            };
            spec = {
              containers = [
                {
                  name = "longhorn-manager";
                  image = "longhornio/longhorn-manager:v1.10.1";
                  imagePullPolicy = "IfNotPresent";
                  securityContext = {
                    privileged = true;
                  };
                  command = [
                    "longhorn-manager"
                    "-d"
                    "daemon"
                    "--engine-image"
                    "longhornio/longhorn-engine:v1.10.1"
                    "--instance-manager-image"
                    "longhornio/longhorn-instance-manager:v1.10.1"
                    "--share-manager-image"
                    "longhornio/longhorn-share-manager:v1.10.1"
                    "--backing-image-manager-image"
                    "longhornio/backing-image-manager:v1.10.1"
                    "--support-bundle-manager-image"
                    "longhornio/support-bundle-kit:v0.0.71"
                    "--manager-image"
                    "longhornio/longhorn-manager:v1.10.1"
                    "--service-account"
                    "longhorn-service-account"
                    "--upgrade-version-check"
                  ];
                  ports = [
                    {
                      containerPort = 9500;
                      name = "manager";
                    }
                    {
                      containerPort = 9502;
                      name = "admission-wh";
                    }
                    {
                      containerPort = 9503;
                      name = "recov-backend";
                    }
                  ];
                  readinessProbe = {
                    httpGet = {
                      path = "/v1/healthz";
                      port = 9502;
                      scheme = "HTTPS";
                    };
                  };
                  volumeMounts = [
                    {
                      name = "boot";
                      mountPath = "/host/boot/";
                      readOnly = true;
                    }
                    {
                      name = "dev";
                      mountPath = "/host/dev/";
                    }
                    {
                      name = "proc";
                      mountPath = "/host/proc/";
                      readOnly = true;
                    }
                    {
                      name = "etc";
                      mountPath = "/host/etc/";
                      readOnly = true;
                    }
                    {
                      name = "longhorn";
                      mountPath = "/var/lib/longhorn/";
                      mountPropagation = "Bidirectional";
                    }
                    {
                      name = "longhorn-grpc-tls";
                      mountPath = "/tls-files/";
                    }
                  ];
                  env = [
                    {
                      name = "POD_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.name";
                        };
                      };
                    }
                    {
                      name = "POD_NAMESPACE";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.namespace";
                        };
                      };
                    }
                    {
                      name = "POD_IP";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "status.podIP";
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
                  ];
                }
                {
                  name = "pre-pull-share-manager-image";
                  imagePullPolicy = "IfNotPresent";
                  image = "longhornio/longhorn-share-manager:v1.10.1";
                  command = [
                    "sh"
                    "-c"
                    "echo share-manager image pulled && sleep infinity"
                  ];
                }
              ];
              volumes = [
                {
                  name = "boot";
                  hostPath = {
                    path = "/boot/";
                  };
                }
                {
                  name = "dev";
                  hostPath = {
                    path = "/dev/";
                  };
                }
                {
                  name = "proc";
                  hostPath = {
                    path = "/proc/";
                  };
                }
                {
                  name = "etc";
                  hostPath = {
                    path = "/etc/";
                  };
                }
                {
                  name = "longhorn";
                  hostPath = {
                    path = "/var/lib/longhorn/";
                  };
                }
                {
                  name = "longhorn-grpc-tls";
                  secret = {
                    secretName = "longhorn-grpc-tls";
                    optional = true;
                  };
                }
              ];
              priorityClassName = "longhorn-critical";
              serviceAccountName = "longhorn-service-account";
            };
          };
          updateStrategy = {
            rollingUpdate = {
              maxUnavailable = "100%";
            };
          };
        };
      }
    ];
  };
}
