{ lib, config, ... }:
let
  cfg = config.homelab.system.longhorn;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.longhorn-job.content = [
      {
        apiVersion = "batch/v1";
        kind = "Job";
        metadata = {
          annotations = {
            "helm.sh/hook" = "post-upgrade";
            "helm.sh/hook-delete-policy" = "hook-succeeded,before-hook-creation";
          };
          name = "longhorn-post-upgrade";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        spec = {
          activeDeadlineSeconds = 900;
          backoffLimit = 1;
          template = {
            metadata = {
              name = "longhorn-post-upgrade";
              labels = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
              };
            };
            spec = {
              containers = [
                {
                  name = "longhorn-post-upgrade";
                  image = "longhornio/longhorn-manager:v1.10.1";
                  imagePullPolicy = "IfNotPresent";
                  command = [
                    "longhorn-manager"
                    "post-upgrade"
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
                  ];
                }
              ];
              restartPolicy = "OnFailure";
              priorityClassName = "longhorn-critical";
              serviceAccountName = "longhorn-service-account";
            };
          };
        };
      }
      {
        apiVersion = "batch/v1";
        kind = "Job";
        metadata = {
          annotations = {
            "helm.sh/hook" = "pre-upgrade";
            "helm.sh/hook-delete-policy" = "hook-succeeded,before-hook-creation,hook-failed";
          };
          name = "longhorn-pre-upgrade";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        spec = {
          activeDeadlineSeconds = 900;
          backoffLimit = 1;
          template = {
            metadata = {
              name = "longhorn-pre-upgrade";
              labels = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
              };
            };
            spec = {
              containers = [
                {
                  name = "longhorn-pre-upgrade";
                  image = "longhornio/longhorn-manager:v1.10.1";
                  imagePullPolicy = "IfNotPresent";
                  securityContext = {
                    privileged = true;
                  };
                  command = [
                    "longhorn-manager"
                    "pre-upgrade"
                  ];
                  volumeMounts = [
                    {
                      name = "proc";
                      mountPath = "/host/proc/";
                    }
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
                  ];
                }
              ];
              volumes = [
                {
                  name = "proc";
                  hostPath = {
                    path = "/proc/";
                  };
                }
              ];
              restartPolicy = "OnFailure";
              serviceAccountName = "longhorn-service-account";
            };
          };
        };
      }
      {
        apiVersion = "batch/v1";
        kind = "Job";
        metadata = {
          annotations = {
            "helm.sh/hook" = "pre-delete";
            "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded";
          };
          name = "longhorn-uninstall";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        spec = {
          activeDeadlineSeconds = 900;
          backoffLimit = 1;
          template = {
            metadata = {
              name = "longhorn-uninstall";
              labels = {
                "app.kubernetes.io/name" = "longhorn";
                "app.kubernetes.io/instance" = "longhorn";
              };
            };
            spec = {
              containers = [
                {
                  name = "longhorn-uninstall";
                  image = "longhornio/longhorn-manager:v1.10.1";
                  imagePullPolicy = "IfNotPresent";
                  command = [
                    "longhorn-manager"
                    "uninstall"
                    "--force"
                  ];
                  env = [
                    {
                      name = "LONGHORN_NAMESPACE";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.namespace";
                        };
                      };
                    }
                  ];
                }
              ];
              restartPolicy = "Never";
              priorityClassName = "longhorn-critical";
              serviceAccountName = "longhorn-service-account";
            };
          };
        };
      }
    ];
  };
}
