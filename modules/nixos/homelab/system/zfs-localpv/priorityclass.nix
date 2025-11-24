{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-priorityclass".content = [
      {
        apiVersion = "scheduling.k8s.io/v1";
        kind = "PriorityClass";
        metadata = {
          name = "openebs-zfs-csi-controller-critical";
        };
        value = 900000000;
        globalDefault = false;
        description = "This priority class should be used for the CStor CSI driver controller deployment only.";
      }
      {
        apiVersion = "scheduling.k8s.io/v1";
        kind = "PriorityClass";
        metadata = {
          name = "openebs-zfs-csi-node-critical";
        };
        value = 900001000;
        globalDefault = false;
        description = "This priority class should be used for the CStor CSI driver node deployment only.";
      }
    ];
  };
}
