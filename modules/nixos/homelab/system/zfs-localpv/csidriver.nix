{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-csidriver".content = [
      {
        apiVersion = "storage.k8s.io/v1";
        kind = "CSIDriver";
        metadata = {
          name = "zfs.csi.openebs.io";
        };
        spec = {
          attachRequired = false;
          podInfoOnMount = false;
          storageCapacity = true;
        };
      }
    ];
  };
}
