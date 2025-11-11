{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-configmap".content = [
      {
        kind = "ConfigMap";
        apiVersion = "v1";
        metadata = {
          name = "openebs-zfspv-bin";
          namespace = "system";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            name = "openebs-zfs-node";
            app = "openebs-zfs-node";
            "openebs.io/component-name" = "openebs-zfs-node";
          };
        };
        data = {
          zfs = "#!/bin/sh\nif [ -x /host/sbin/zfs ]; then\n  chroot /host /sbin/zfs \"$@\"\nelif [ -x /host/usr/sbin/zfs ]; then\n  chroot /host /usr/sbin/zfs \"$@\"\nelse\n  chroot /host \"zfs\" \"$@\"\nfi";
        };
      }
    ];
  };
}
