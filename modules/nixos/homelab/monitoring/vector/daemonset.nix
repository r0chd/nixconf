{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.vector.enable) {
    services.k3s.manifests."vector-daemonset".content = [
      {
        apiVersion = "apps/v1";
        kind = "DaemonSet";
        metadata = {
          name = "vector";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
            "app.kubernetes.io/version" = "0.51.0-distroless-libc";
          };
        };
        spec = {
          selector = {
            matchLabels = {
              "app.kubernetes.io/name" = "vector";
              "app.kubernetes.io/instance" = "vector";
              "app.kubernetes.io/component" = "Agent";
            };
          };
          minReadySeconds = 0;
          template = {
            metadata = {
              annotations = { };
              labels = {
                "app.kubernetes.io/name" = "vector";
                "app.kubernetes.io/instance" = "vector";
                "app.kubernetes.io/component" = "Agent";
                "vector.dev/exclude" = "true";
              };
            };
            spec = {
              serviceAccountName = "vector";
              dnsPolicy = "ClusterFirst";
              containers = [
                {
                  name = "vector";
                  image = "timberio/vector:0.51.0-distroless-libc";
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "--config-dir"
                    "/etc/vector/"
                  ];
                  env = [
                    {
                      name = "VECTOR_LOG";
                      value = "info";
                    }
                    {
                      name = "VECTOR_SELF_NODE_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "spec.nodeName";
                        };
                      };
                    }
                    {
                      name = "VECTOR_SELF_POD_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.name";
                        };
                      };
                    }
                    {
                      name = "VECTOR_SELF_POD_NAMESPACE";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.namespace";
                        };
                      };
                    }
                    {
                      name = "PROCFS_ROOT";
                      value = "/host/proc";
                    }
                    {
                      name = "SYSFS_ROOT";
                      value = "/host/sys";
                    }
                  ];
                  ports = [
                    {
                      name = "prom-exporter";
                      containerPort = 9090;
                      protocol = "TCP";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "data";
                      mountPath = "/vector-data-dir";
                    }
                    {
                      name = "config";
                      mountPath = "/etc/vector/";
                      readOnly = true;
                    }
                    {
                      mountPath = "/var/log/";
                      name = "var-log";
                      readOnly = true;
                    }
                    {
                      mountPath = "/var/lib";
                      name = "var-lib";
                      readOnly = true;
                    }
                    {
                      mountPath = "/host/proc";
                      name = "procfs";
                      readOnly = true;
                    }
                    {
                      mountPath = "/host/sys";
                      name = "sysfs";
                      readOnly = true;
                    }
                  ];
                }
              ];
              terminationGracePeriodSeconds = 60;
              volumes = [
                {
                  name = "config";
                  projected = {
                    sources = [
                      {
                        configMap = {
                          name = "vector";
                        };
                      }
                    ];
                  };
                }
                {
                  name = "data";
                  hostPath = {
                    path = "/var/lib/vector";
                  };
                }
                {
                  hostPath = {
                    path = "/var/log/";
                  };
                  name = "var-log";
                }
                {
                  hostPath = {
                    path = "/var/lib/";
                  };
                  name = "var-lib";
                }
                {
                  hostPath = {
                    path = "/proc";
                  };
                  name = "procfs";
                }
                {
                  hostPath = {
                    path = "/sys";
                  };
                  name = "sysfs";
                }
              ];
            };
          };
        };
      }
    ];
  };
}
