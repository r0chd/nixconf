{ config, lib, ... }:
let
  cfg = config.homelab.atuin;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."atuin-pvc".content = [
      {
        apiVersion = "v1";
        kind = "PersistentVolumeClaim";
        metadata = {
          labels."io.kompose.service" = "atuin-claim0";
          name = "atuin-claim0";
          namespace = "atuin";
        };
        spec = {
          storageClassName = config.homelab.storageClass;
          accessModes = [ "ReadWriteOnce" ];
          resources.requests.storage = cfg.storageSize;
        };
      }
    ];
  };
}
