{ config, lib, ... }:
let
  cfg = config.homelab.immich;
in
{
  config.services.k3s.autoDeployCharts.immich.extraDeploy = lib.mkIf cfg.enable [
    {
      apiVersion = "v1";
      kind = "PersistentVolumeClaim";
      metadata.name = "vaultwarden-pvc";
      spec = {
        accessModes = [ "ReadWriteOnce" ];
        storageClassName = "openebs-hostpath";
        resources.requests.storage = "5G"; # TODO: make it into an option
      };
    }
  ];
}
