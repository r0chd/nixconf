{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."thanos-compact-pvc".content = [
      {
        apiVersion = "v1";
        kind = "PersistentVolumeClaim";
        metadata = {
          name = "thanos-compact";
          namespace = "monitoring";
        };
        spec = {
          accessModes = [ "ReadWriteOnce" ];
          resources.requests.storage = "100Gi";
          storageClassName = config.homelab.storageClass;
        };
      }
    ];
  };
}
