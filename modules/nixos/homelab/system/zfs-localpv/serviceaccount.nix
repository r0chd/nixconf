{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-serviceaccount".content = [
      {
        kind = "ServiceAccount";
        apiVersion = "v1";
        metadata = {
          name = "openebs-zfs-controller-sa";
          namespace = "system";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            app = "openebs-zfs-controller";
            component = "openebs-zfs-controller";
            "openebs.io/component-name" = "openebs-zfs-controller";
          };
        };
      }
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "openebs-zfs-node-sa";
          namespace = "system";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            name = "openebs-zfs-node";
            app = "openebs-zfs-node";
            "openebs.io/component-name" = "openebs-zfs-node";
          };
        };
      }
    ];
  };
}
