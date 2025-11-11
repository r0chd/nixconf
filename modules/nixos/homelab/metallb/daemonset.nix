{ ... }:
{
  services.k3s.manifests."metallb-daemonset".content = [
    {
      apiVersion = "apps/v1";
      kind = "DaemonSet";
      metadata = {
        name = "metallb-speaker";
        namespace = "default";
        labels = {
          "app.kubernetes.io/name" = "metallb";
          "app.kubernetes.io/instance" = "metallb";
          "app.kubernetes.io/version" = "v0.15.2";
          "app.kubernetes.io/component" = "speaker";
        };
      };
      spec = {
        updateStrategy = {
          type = "RollingUpdate";
        };
        selector = {
          matchLabels = {
            "app.kubernetes.io/name" = "metallb";
            "app.kubernetes.io/instance" = "metallb";
            "app.kubernetes.io/component" = "speaker";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/name" = "metallb";
              "app.kubernetes.io/instance" = "metallb";
              "app.kubernetes.io/component" = "speaker";
            };
          };
          spec = {
            serviceAccountName = "metallb-speaker";
            terminationGracePeriodSeconds = 0;
            hostNetwork = true;
            volumes = [
              {
                name = "memberlist";
                secret = {
                  secretName = "metallb-memberlist";
                  defaultMode = 420;
                };
              }
              {
                name = "metallb-excludel2";
                configMap = {
                  defaultMode = 256;
                  name = "metallb-excludel2";
                };
              }
              {
                name = "frr-sockets";
                emptyDir = { };
              }
              {
                name = "frr-startup";
                configMap = {
                  name = "metallb-frr-startup";
                };
              }
              {
                name = "frr-conf";
                emptyDir = { };
              }
              {
                name = "reloader";
                emptyDir = { };
              }
              {
                name = "metrics";
                emptyDir = { };
              }
            ];
            initContainers = [
              {
                name = "cp-frr-files";
                image = "quay.io/frrouting/frr:9.1.0";
                securityContext = {
                  runAsUser = 100;
                  runAsGroup = 101;
                };
                command = [
                  "/bin/sh"
                  "-c"
                  "cp -rLf /tmp/frr/* /etc/frr/"
                ];
                volumeMounts = [
                  {
                    name = "frr-startup";
                    mountPath = "/tmp/frr";
                  }
                  {
                    name = "frr-conf";
                    mountPath = "/etc/frr";
                  }
                ];
              }
              {
                name = "cp-reloader";
                image = "quay.io/metallb/speaker:v0.15.2";
                command = [
                  "/cp-tool"
                  "/frr-reloader.sh"
                  "/etc/frr_reloader/frr-reloader.sh"
                ];
                volumeMounts = [
                  {
                    name = "reloader";
                    mountPath = "/etc/frr_reloader";
                  }
                ];
              }
              {
                name = "cp-metrics";
                image = "quay.io/metallb/speaker:v0.15.2";
                command = [
                  "/cp-tool"
                  "/frr-metrics"
                  "/etc/frr_metrics/frr-metrics"
                ];
                volumeMounts = [
                  {
                    name = "metrics";
                    mountPath = "/etc/frr_metrics";
                  }
                ];
              }
            ];
            shareProcessNamespace = true;
            containers = [
              {
                name = "speaker";
                image = "quay.io/metallb/speaker:v0.15.2";
                args = [
                  "--port=7472"
                  "--log-level=info"
                ];
                env = [
                  {
                    name = "METALLB_NODE_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "spec.nodeName";
                      };
                    };
                  }
                  {
                    name = "METALLB_HOST";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "status.hostIP";
                      };
                    };
                  }
                  {
                    name = "METALLB_ML_BIND_ADDR";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "status.podIP";
                      };
                    };
                  }
                  {
                    name = "METALLB_ML_LABELS";
                    value = "app.kubernetes.io/name=metallb,app.kubernetes.io/component=speaker";
                  }
                  {
                    name = "METALLB_ML_BIND_PORT";
                    value = "7946";
                  }
                  {
                    name = "METALLB_ML_SECRET_KEY_PATH";
                    value = "/etc/ml_secret_key";
                  }
                  {
                    name = "FRR_CONFIG_FILE";
                    value = "/etc/frr_reloader/frr.conf";
                  }
                  {
                    name = "FRR_RELOADER_PID_FILE";
                    value = "/etc/frr_reloader/reloader.pid";
                  }
                  {
                    name = "METALLB_BGP_TYPE";
                    value = "frr";
                  }
                  {
                    name = "METALLB_POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                ];
                ports = [
                  {
                    name = "monitoring";
                    containerPort = 7472;
                  }
                  {
                    name = "memberlist-tcp";
                    containerPort = 7946;
                    protocol = "TCP";
                  }
                  {
                    name = "memberlist-udp";
                    containerPort = 7946;
                    protocol = "UDP";
                  }
                ];
                livenessProbe = {
                  httpGet = {
                    path = "/metrics";
                    port = "monitoring";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  timeoutSeconds = 1;
                  successThreshold = 1;
                  failureThreshold = 3;
                };
                readinessProbe = {
                  httpGet = {
                    path = "/metrics";
                    port = "monitoring";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  timeoutSeconds = 1;
                  successThreshold = 1;
                  failureThreshold = 3;
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  readOnlyRootFilesystem = true;
                  capabilities = {
                    drop = [ "ALL" ];
                    add = [ "NET_RAW" ];
                  };
                };
                volumeMounts = [
                  {
                    name = "memberlist";
                    mountPath = "/etc/ml_secret_key";
                  }
                  {
                    name = "reloader";
                    mountPath = "/etc/frr_reloader";
                  }
                  {
                    name = "metallb-excludel2";
                    mountPath = "/etc/metallb";
                  }
                ];
              }
              {
                name = "frr";
                securityContext = {
                  capabilities = {
                    add = [
                      "NET_ADMIN"
                      "NET_RAW"
                      "SYS_ADMIN"
                      "NET_BIND_SERVICE"
                    ];
                  };
                };
                image = "quay.io/frrouting/frr:9.1.0";
                env = [
                  {
                    name = "TINI_SUBREAPER";
                    value = "true";
                  }
                ];
                volumeMounts = [
                  {
                    name = "frr-sockets";
                    mountPath = "/var/run/frr";
                  }
                  {
                    name = "frr-conf";
                    mountPath = "/etc/frr";
                  }
                ];
                command = [
                  "/bin/sh"
                  "-c"
                  "/sbin/tini -- /usr/lib/frr/docker-start &\nattempts=0\nuntil [[ -f /etc/frr/frr.log || $attempts -eq 60 ]]; do\n  sleep 1\n  attempts=$(( $attempts + 1 ))\ndone\ntail -f /etc/frr/frr.log\n"
                ];
                livenessProbe = {
                  httpGet = {
                    path = "livez";
                    port = 7473;
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  timeoutSeconds = 1;
                  successThreshold = 1;
                  failureThreshold = 3;
                };
                startupProbe = {
                  httpGet = {
                    path = "/livez";
                    port = 7473;
                  };
                  failureThreshold = 30;
                  periodSeconds = 5;
                };
              }
              {
                name = "reloader";
                image = "quay.io/frrouting/frr:9.1.0";
                command = [ "/etc/frr_reloader/frr-reloader.sh" ];
                volumeMounts = [
                  {
                    name = "frr-sockets";
                    mountPath = "/var/run/frr";
                  }
                  {
                    name = "frr-conf";
                    mountPath = "/etc/frr";
                  }
                  {
                    name = "reloader";
                    mountPath = "/etc/frr_reloader";
                  }
                ];
              }
              {
                name = "frr-metrics";
                image = "quay.io/frrouting/frr:9.1.0";
                command = [ "/etc/frr_metrics/frr-metrics" ];
                args = [ "--metrics-port=7473" ];
                env = [
                  {
                    name = "VTYSH_HISTFILE";
                    value = "/dev/null";
                  }
                ];
                ports = [
                  {
                    containerPort = 7473;
                    name = "monitoring";
                  }
                ];
                volumeMounts = [
                  {
                    name = "frr-sockets";
                    mountPath = "/var/run/frr";
                  }
                  {
                    name = "frr-conf";
                    mountPath = "/etc/frr";
                  }
                  {
                    name = "metrics";
                    mountPath = "/etc/frr_metrics";
                  }
                ];
              }
            ];
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
            tolerations = [
              {
                key = "node-role.kubernetes.io/master";
                effect = "NoSchedule";
                operator = "Exists";
              }
              {
                key = "node-role.kubernetes.io/control-plane";
                effect = "NoSchedule";
                operator = "Exists";
              }
            ];
          };
        };
      };
    }
  ];
}
