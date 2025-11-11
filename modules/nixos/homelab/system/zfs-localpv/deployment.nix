{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "openebs-zfs-localpv-controller";
          namespace = "system";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            app = "openebs-zfs-controller";
            component = "openebs-zfs-controller";
            "openebs.io/component-name" = "openebs-zfs-controller";
          };
        };
        spec = {
          selector = {
            matchLabels = {
              app = "openebs-zfs-controller";
              component = "openebs-zfs-controller";
            };
          };
          replicas = 1;
          template = {
            metadata = {
              labels = {
                "openebs.io/version" = "2.9.0-develop";
                role = "openebs-zfs";
                app = "openebs-zfs-controller";
                component = "openebs-zfs-controller";
                "openebs.io/component-name" = "openebs-zfs-controller";
                name = "openebs-zfs-controller";
                "openebs.io/logging" = "true";
              };
            };
            spec = {
              priorityClassName = "openebs-zfs-csi-controller-critical";
              serviceAccountName = "openebs-zfs-controller-sa";
              containers = [
                {
                  name = "csi-resizer";
                  image = "registry.k8s.io/sig-storage/csi-resizer:v1.13.2";
                  args = [
                    "--v=5"
                    "--csi-address=$(ADDRESS)"
                  ];
                  env = [
                    {
                      name = "ADDRESS";
                      value = "/var/lib/csi/sockets/pluginproxy/csi.sock";
                    }
                  ];
                  imagePullPolicy = "IfNotPresent";
                  volumeMounts = [
                    {
                      name = "socket-dir";
                      mountPath = "/var/lib/csi/sockets/pluginproxy/";
                    }
                  ];
                  resources = { };
                }
                {
                  name = "csi-snapshotter";
                  image = "registry.k8s.io/sig-storage/csi-snapshotter:v8.2.0";
                  imagePullPolicy = "IfNotPresent";
                  args = [ "--csi-address=$(ADDRESS)" ];
                  env = [
                    {
                      name = "ADDRESS";
                      value = "/var/lib/csi/sockets/pluginproxy/csi.sock";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "socket-dir";
                      mountPath = "/var/lib/csi/sockets/pluginproxy/";
                    }
                  ];
                  resources = { };
                }
                {
                  name = "snapshot-controller";
                  image = "registry.k8s.io/sig-storage/snapshot-controller:v8.2.0";
                  args = [ "--v=5" ];
                  imagePullPolicy = "IfNotPresent";
                  resources = { };
                }
                {
                  name = "csi-provisioner";
                  image = "registry.k8s.io/sig-storage/csi-provisioner:v5.2.0";
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "--csi-address=$(ADDRESS)"
                    "--v=5"
                    "--feature-gates=Topology=true"
                    "--strict-topology"
                    "--enable-capacity=true"
                    "--extra-create-metadata=true"
                    "--default-fstype=ext4"
                  ];
                  env = [
                    {
                      name = "ADDRESS";
                      value = "/var/lib/csi/sockets/pluginproxy/csi.sock";
                    }
                    {
                      name = "NAMESPACE";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.namespace";
                        };
                      };
                    }
                    {
                      name = "POD_NAME";
                      valueFrom = {
                        fieldRef = {
                          fieldPath = "metadata.name";
                        };
                      };
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "socket-dir";
                      mountPath = "/var/lib/csi/sockets/pluginproxy/";
                    }
                  ];
                  resources = { };
                }
                {
                  name = "openebs-zfs-plugin";
                  image = "openebs/zfs-driver:2.9.0-develop";
                  imagePullPolicy = "IfNotPresent";
                  env = [
                    {
                      name = "OPENEBS_CONTROLLER_DRIVER";
                      value = "controller";
                    }
                    {
                      name = "OPENEBS_CSI_ENDPOINT";
                      value = "unix:///var/lib/csi/sockets/pluginproxy/csi.sock";
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
                      name = "OPENEBS_IO_INSTALLER_TYPE";
                      value = "zfs-operator";
                    }
                    {
                      name = "OPENEBS_IO_ENABLE_ANALYTICS";
                      value = "true";
                    }
                    {
                      name = "OPENEBS_IO_ENABLE_BACKUP_GC";
                      value = "false";
                    }
                  ];
                  args = [
                    "--endpoint=$(OPENEBS_CSI_ENDPOINT)"
                    "--plugin=$(OPENEBS_CONTROLLER_DRIVER)"
                  ];
                  volumeMounts = [
                    {
                      name = "socket-dir";
                      mountPath = "/var/lib/csi/sockets/pluginproxy/";
                    }
                  ];
                  resources = { };
                }
              ];
              volumes = [
                {
                  name = "socket-dir";
                  emptyDir = { };
                }
              ];
            };
          };
        };
      }
    ];
  };
}
