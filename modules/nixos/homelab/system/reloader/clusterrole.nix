{ ... }:
{
  services.k3s.manifests."reloader-clusterrole".content = [
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "reloader-reloader-role";
        labels = {
          app = "reloader-reloader";
          "app.kubernetes.io/managed-by" = "NixOS";
        };
      };
      rules = [
        {
          apiGroups = [ "" ];
          resources = [
            "secrets"
            "configmaps"
          ];
          verbs = [
            "list"
            "get"
            "watch"
          ];
        }
        {
          apiGroups = [ "apps" ];
          resources = [
            "deployments"
            "daemonsets"
            "statefulsets"
          ];
          verbs = [
            "list"
            "get"
            "update"
            "patch"
          ];
        }
        {
          apiGroups = [ "extensions" ];
          resources = [
            "deployments"
            "daemonsets"
          ];
          verbs = [
            "list"
            "get"
            "update"
            "patch"
          ];
        }
        {
          apiGroups = [ "batch" ];
          resources = [ "cronjobs" ];
          verbs = [
            "list"
            "get"
          ];
        }
        {
          apiGroups = [ "batch" ];
          resources = [ "jobs" ];
          verbs = [ "create" ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "events" ];
          verbs = [
            "create"
            "patch"
          ];
        }
      ];
    }
  ];
}
