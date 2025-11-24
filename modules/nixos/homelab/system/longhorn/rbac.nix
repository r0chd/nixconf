{ lib, config, ... }:
let
  cfg = config.homelab.system.longhorn;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.longhorn-rbac.content = [
      {
        apiVersion = "scheduling.k8s.io/v1";
        kind = "PriorityClass";
        metadata = {
          name = "longhorn-critical";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        description = "Ensure Longhorn pods have the highest priority to prevent any unexpected eviction by the Kubernetes scheduler under node pressure";
        globalDefault = false;
        preemptionPolicy = "PreemptLowerPriority";
        value = 1000000000;
      }
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "longhorn-service-account";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
      }
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "longhorn-ui-service-account";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
      }
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "longhorn-support-bundle";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = {
          name = "longhorn-role";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            namespace = "system";
          };
        };
        rules = [
          {
            apiGroups = [ "apiextensions.k8s.io" ];
            resources = [ "customresourcedefinitions" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "pods" ];
            verbs = [
              "get"
              "list"
              "watch"
              "delete"
              "deletecollection"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [
              "secrets"
              "services"
              "endpoints"
              "configmaps"
              "serviceaccounts"
              "pods/log"
            ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [
              "events"
              "persistentvolumes"
              "persistentvolumeclaims"
              "persistentvolumeclaims/status"
              "nodes"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "namespaces" ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "apps" ];
            resources = [
              "daemonsets"
              "statefulsets"
              "deployments"
              "replicasets"
            ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "batch" ];
            resources = [
              "jobs"
              "cronjobs"
            ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "policy" ];
            resources = [ "poddisruptionbudgets" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "scheduling.k8s.io" ];
            resources = [ "priorityclasses" ];
            verbs = [
              "watch"
              "list"
            ];
          }
          {
            apiGroups = [ "storage.k8s.io" ];
            resources = [
              "storageclasses"
              "volumeattachments"
              "volumeattachments/status"
              "csinodes"
              "csidrivers"
              "csistoragecapacities"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "snapshot.storage.k8s.io" ];
            resources = [
              "volumesnapshotclasses"
              "volumesnapshots"
              "volumesnapshotcontents"
              "volumesnapshotcontents/status"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "longhorn.io" ];
            resources = [
              "volumes"
              "volumes/status"
              "engines"
              "engines/status"
              "replicas"
              "replicas/status"
              "settings"
              "settings/status"
              "engineimages"
              "engineimages/status"
              "nodes"
              "nodes/status"
              "instancemanagers"
              "instancemanagers/status"
              "sharemanagers"
              "sharemanagers/status"
              "backingimages"
              "backingimages/status"
              "backingimagemanagers"
              "backingimagemanagers/status"
              "backingimagedatasources"
              "backingimagedatasources/status"
              "backuptargets"
              "backuptargets/status"
              "backupvolumes"
              "backupvolumes/status"
              "backups"
              "backups/status"
              "recurringjobs"
              "recurringjobs/status"
              "orphans"
              "orphans/status"
              "snapshots"
              "snapshots/status"
              "supportbundles"
              "supportbundles/status"
              "systembackups"
              "systembackups/status"
              "systemrestores"
              "systemrestores/status"
              "volumeattachments"
              "volumeattachments/status"
              "backupbackingimages"
              "backupbackingimages/status"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "coordination.k8s.io" ];
            resources = [ "leases" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "metrics.k8s.io" ];
            resources = [
              "pods"
              "nodes"
            ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "apiregistration.k8s.io" ];
            resources = [ "apiservices" ];
            verbs = [
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "admissionregistration.k8s.io" ];
            resources = [
              "mutatingwebhookconfigurations"
              "validatingwebhookconfigurations"
            ];
            verbs = [
              "get"
              "list"
              "create"
              "patch"
              "delete"
            ];
          }
          {
            apiGroups = [ "rbac.authorization.k8s.io" ];
            resources = [
              "roles"
              "rolebindings"
            ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "discovery.k8s.io" ];
            resources = [ "endpointslices" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
          {
            apiGroups = [ "rbac.authorization.k8s.io" ];
            resources = [
              "clusterrolebindings"
              "clusterroles"
            ];
            verbs = [ "*" ];
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "longhorn-bind";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "longhorn-role";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "longhorn-service-account";
            namespace = "system";
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "longhorn-support-bundle";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "cluster-admin";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "longhorn-support-bundle";
            namespace = "system";
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "Role";
        metadata = {
          name = "longhorn";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [
              "pods"
              "pods/log"
              "events"
              "secrets"
              "services"
              "endpoints"
              "configmaps"
              "serviceaccounts"
              "persistentvolumeclaims"
              "persistentvolumeclaims/status"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "apps" ];
            resources = [
              "daemonsets"
              "deployments"
              "statefulsets"
              "replicasets"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "batch" ];
            resources = [
              "jobs"
              "cronjobs"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "policy" ];
            resources = [ "poddisruptionbudgets" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "coordination.k8s.io" ];
            resources = [ "leases" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "rbac.authorization.k8s.io" ];
            resources = [
              "roles"
              "rolebindings"
            ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "discovery.k8s.io" ];
            resources = [ "endpointslices" ];
            verbs = [ "*" ];
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "RoleBinding";
        metadata = {
          name = "longhorn";
          namespace = "system";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "Role";
          name = "longhorn";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "longhorn-service-account";
            namespace = "system";
          }
        ];
      }
    ];
  };
}
