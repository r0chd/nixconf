{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-storageclass".content = [
      {
        apiVersion = "storage.k8s.io/v1";
        kind = "StorageClass";
        metadata = {
          name = "openebs-zfs-localpv";
        };
        provisioner = "zfs.csi.openebs.io";
        allowVolumeExpansion = true;
        parameters = {
          scheduler = "CapacityWeighted";
          fstype = "zfs";
          inherit (cfg) poolname;
        };
      }
    ];
  };
}
