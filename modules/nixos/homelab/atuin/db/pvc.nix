{ config, lib, ... }:
let
  cfg = config.homelab.atuin.db;
in
{
  services.k3s.manifests.atuin.content = [
    {
      apiVersion = "v1";
      kind = "PersistentVolumeClaim";
      metadata = {
        labels."io.kompose.service" = "database";
        name = "database";
        namespace = "atuin";
      };
      spec = {
        storageClassName = "openebs-hostpath";
        accessModes = [ "ReadWriteOnce" ];
        resources.requests = lib.mkIf (cfg.resources.storage != null) { inherit (cfg.resources) storage; };
      };
    }
  ];
}
