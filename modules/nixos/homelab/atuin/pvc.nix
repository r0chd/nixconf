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
        labels."io.kompose.service" = "atuin-claim0";
        name = "atuin-claim0";
        namespace = "atuin";
      };
      spec = {
        storageClassName = "local-path";
        accessModes = [ "ReadWriteOnce" ];
        resources.requests = lib.mkIf (cfg.resources.storage != null) { inherit (cfg.resources) storage; };
      };
    }
  ];
}
