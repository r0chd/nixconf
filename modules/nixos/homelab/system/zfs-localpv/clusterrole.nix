{ config, lib, ... }:
let
  cfg = config.homelab.system.zfs-localpv;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."zfs-localpv-clusterrole".content = [
      {
        kind = "ClusterRole";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "openebs-zfs-provisioner-role";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            app = "openebs-zfs-controller";
            component = "openebs-zfs-controller";
            "openebs.io/component-name" = "openebs-zfs-controller";
          };
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "secrets" ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "namespaces" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "" ];
            resources = [
              "persistentvolumes"
              "services"
            ];
            verbs = [
              "get"
              "list"
              "watch"
              "create"
              "delete"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "persistentvolumeclaims" ];
            verbs = [
              "get"
              "list"
              "watch"
              "update"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "persistentvolumeclaims/status" ];
            verbs = [
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "storage.k8s.io" ];
            resources = [
              "storageclasses"
              "csinodes"
            ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "storage.k8s.io" ];
            resources = [ "csistoragecapacities" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "events" ];
            verbs = [
              "list"
              "watch"
              "create"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "coordination.k8s.io" ];
            resources = [ "leases" ];
            verbs = [
              "get"
              "watch"
              "list"
              "delete"
              "update"
              "create"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "nodes" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "pods" ];
            verbs = [
              "get"
              "list"
              "watch"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "pods" ];
            verbs = [
              "get"
              "list"
              "watch"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "*" ];
            resources = [
              "zfsvolumes"
              "zfssnapshots"
              "zfsbackups"
              "zfsrestores"
              "zfsnodes"
            ];
            verbs = [ "*" ];
          }
        ];
      }
      {
        kind = "ClusterRole";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "openebs-zfs-snapshotter-role";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            app = "openebs-zfs-controller";
            component = "openebs-zfs-controller";
            "openebs.io/component-name" = "openebs-zfs-controller";
          };
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "persistentvolumes" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "persistentvolumeclaims" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "storage.k8s.io" ];
            resources = [ "storageclasses" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "events" ];
            verbs = [
              "list"
              "watch"
              "create"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "secrets" ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "snapshot.storage.k8s.io" ];
            resources = [ "volumesnapshotclasses" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "snapshot.storage.k8s.io" ];
            resources = [ "volumesnapshotcontents" ];
            verbs = [
              "create"
              "get"
              "list"
              "watch"
              "update"
              "delete"
              "patch"
            ];
          }
          {
            apiGroups = [ "snapshot.storage.k8s.io" ];
            resources = [ "volumesnapshots" ];
            verbs = [
              "get"
              "list"
              "watch"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "snapshot.storage.k8s.io" ];
            resources = [ "volumesnapshotcontents/status" ];
            verbs = [
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "snapshot.storage.k8s.io" ];
            resources = [ "volumesnapshots/status" ];
            verbs = [ "update" ];
          }
          {
            apiGroups = [ "apiextensions.k8s.io" ];
            resources = [ "customresourcedefinitions" ];
            verbs = [
              "create"
              "list"
              "watch"
              "delete"
            ];
          }
        ];
      }
      {
        kind = "ClusterRole";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "openebs-zfs-driver-registrar-role";
          labels = {
            "openebs.io/version" = "2.9.0-develop";
            role = "openebs-zfs";
            name = "openebs-zfs-node";
            app = "openebs-zfs-node";
            "openebs.io/component-name" = "openebs-zfs-node";
          };
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "events" ];
            verbs = [
              "get"
              "list"
              "watch"
              "create"
              "update"
              "patch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [
              "persistentvolumes"
              "nodes"
              "services"
            ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "*" ];
            resources = [
              "zfsvolumes"
              "zfssnapshots"
              "zfsbackups"
              "zfsrestores"
              "zfsnodes"
            ];
            verbs = [
              "get"
              "list"
              "watch"
              "create"
              "update"
              "patch"
            ];
          }
        ];
      }
    ];
  };
}
