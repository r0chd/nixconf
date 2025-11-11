{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-clusterrolebinding".content = [
      {
        kind = "ClusterRoleBinding";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "openebs-zfs-provisioner-binding";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            app = "openebs-zfs-controller";
            component = "openebs-zfs-controller";
            "openebs.io/component-name" = "openebs-zfs-controller";
          };
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "openebs-zfs-controller-sa";
            namespace = "system";
          }
        ];
        roleRef = {
          kind = "ClusterRole";
          name = "openebs-zfs-provisioner-role";
          apiGroup = "rbac.authorization.k8s.io";
        };
      }
      {
        kind = "ClusterRoleBinding";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "openebs-zfs-snapshotter-binding";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            app = "openebs-zfs-controller";
            component = "openebs-zfs-controller";
            "openebs.io/component-name" = "openebs-zfs-controller";
          };
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "openebs-zfs-controller-sa";
            namespace = "system";
          }
        ];
        roleRef = {
          kind = "ClusterRole";
          name = "openebs-zfs-snapshotter-role";
          apiGroup = "rbac.authorization.k8s.io";
        };
      }
      {
        kind = "ClusterRoleBinding";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "openebs-zfs-driver-registrar-binding";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            name = "openebs-zfs-node";
            app = "openebs-zfs-node";
            "openebs.io/component-name" = "openebs-zfs-node";
          };
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "openebs-zfs-node-sa";
            namespace = "system";
          }
        ];
        roleRef = {
          kind = "ClusterRole";
          name = "openebs-zfs-driver-registrar-role";
          apiGroup = "rbac.authorization.k8s.io";
        };
      }
    ];
  };
}
