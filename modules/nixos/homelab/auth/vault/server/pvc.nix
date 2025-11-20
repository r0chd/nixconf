{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-pvc".content = [
      {
        apiVersion = "v1";
        kind = "PersistentVolumeClaim";
        metadata = {
          name = "vault-data";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        spec = {
          accessModes = [ "ReadWriteOnce" ];
          resources.requests.storage = "10Gi";
          storageClassName = config.homelab.storageClass;
        };
      }
    ];
  };
}
