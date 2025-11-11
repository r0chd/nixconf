{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-daemonset".content = [
      {
        kind = "DaemonSet";
        apiVersion = "apps/v1";
        metadata = {
          name = "openebs-zfs-localpv-node";
          namespace = "system";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            name = "openebs-zfs-node";
            app = "openebs-zfs-node";
            "openebs.io/component-name" = "openebs-zfs-node";
          };
        };
        spec = {
          selector = {
            matchLabels = {
              name = "openebs-zfs-node";
            };
          };
          updateStrategy = {
            rollingUpdate = {
              maxUnavailable = "100%";
            };
            type = "RollingUpdate";
          };
          template = {
            metadata = {
              labels = {
                "openebs.io/version" = "2.9.0-develop";
                role = "openebs-zfs";
                name = "openebs-zfs-node";
                app = "openebs-zfs-node";
                "openebs.io/component-name" = "openebs-zfs-node";
                "openebs.io/logging" = "true";
              };
            };
            spec = {
              priorityClassName = "openebs-zfs-csi-node-critical";
              serviceAccountName = "openebs-zfs-node-sa";
              hostNetwork = true;
              containers = [
                {
                  name = "csi-node-driver-registrar";
                  image = "registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.13.0";
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "--v=5"
                    "--csi-address=$(ADDRESS)"
                    "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)"
                  ];
                  lifecycle = {
                    preStop = {
                      exec = {
                        command = [
                          "/bin/sh"
                          "-c"
                          "rm -rf /registration/zfs-localpv /registration/zfs-localpv-reg.sock"
                        ];
                      };
                    };
                  };
                  env = [
                    {
                      name = "ADDRESS";
                      value = "/plugin/csi.sock";
                    }
                    {
                      name = "DRIVER_REG_SOCK_PATH";
                      value = "/var/lib/rancher/k3s/agent/kubelet/plugins/zfs-localpv/csi.sock";
                    }
                    {
                      name = "KUBE_NODE_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "spec.nodeName";
                        };
                      };
                    }
                    {
                      name = "NODE_DRIVER";
                      value = "openebs-zfs";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "plugin-dir";
                      mountPath = "/plugin";
                    }
                    {
                      name = "registration-dir";
                      mountPath = "/registration";
                    }
                  ];
                  resources = { };
                }
                {
                  name = "openebs-zfs-plugin";
                  securityContext = {
                    privileged = true;
                    allowPrivilegeEscalation = true;
                  };
                  image = "openebs/zfs-driver:2.9.0-develop";
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "--nodename=$(OPENEBS_NODE_NAME)"
                    "--endpoint=$(OPENEBS_CSI_ENDPOINT)"
                    "--plugin=$(OPENEBS_NODE_DRIVER)"
                  ];
                  env = [
                    {
                      name = "OPENEBS_NODE_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "spec.nodeName";
                        };
                      };
                    }
                    {
                      name = "OPENEBS_CSI_ENDPOINT";
                      value = "unix:///plugin/csi.sock";
                    }
                    {
                      name = "OPENEBS_NODE_DRIVER";
                      value = "agent";
                    }
                    {
                      name = "OPENEBS_NAMESPACE";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.namespace";
                        };
                      };
                    }
                    {
                      name = "ALLOWED_TOPOLOGIES";
                      value = "All";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "plugin-dir";
                      mountPath = "/plugin";
                    }
                    {
                      name = "device-dir";
                      mountPath = "/dev";
                    }
                    {
                      name = "encr-keys";
                      mountPath = "/home/keys";
                    }
                    {
                      name = "chroot-zfs";
                      mountPath = "/sbin/zfs";
                      subPath = "zfs";
                    }
                    {
                      name = "host-root";
                      mountPath = "/host";
                      mountPropagation = "HostToContainer";
                      readOnly = true;
                    }
                    {
                      name = "pods-mount-dir";
                      mountPath = "/var/lib/rancher/k3s/agent/kubelet/";
                      mountPropagation = "Bidirectional";
                    }
                  ];
                  resources = { };
                }
              ];
              volumes = [
                {
                  name = "device-dir";
                  hostPath = {
                    path = "/dev";
                    type = "Directory";
                  };
                }
                {
                  name = "encr-keys";
                  hostPath = {
                    path = "/home/keys";
                    type = "DirectoryOrCreate";
                  };
                }
                {
                  name = "chroot-zfs";
                  configMap = {
                    defaultMode = "0555";
                    name = "openebs-zfspv-bin";
                  };
                }
                {
                  name = "host-root";
                  hostPath = {
                    path = "/";
                    type = "Directory";
                  };
                }
                {
                  name = "registration-dir";
                  hostPath = {
                    path = "/var/lib/rancher/k3s/agent/kubelet/plugins_registry/";
                    type = "DirectoryOrCreate";
                  };
                }
                {
                  name = "plugin-dir";
                  hostPath = {
                    path = "/var/lib/rancher/k3s/agent/kubelet/plugins/zfs-localpv/";
                    type = "DirectoryOrCreate";
                  };
                }
                {
                  name = "pods-mount-dir";
                  hostPath = {
                    path = "/var/lib/rancher/k3s/agent/kubelet/";
                    type = "Directory";
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
