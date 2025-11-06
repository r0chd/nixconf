{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-server-pvc".content = [
      {
        apiVersion = "v1";
        kind = "PersistentVolumeClaim";
        metadata = {
          name = "vault-data";
          namespace = "vault";
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
