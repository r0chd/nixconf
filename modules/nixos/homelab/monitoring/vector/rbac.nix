{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.vector.enable) {
    services.k3s.manifests."vector-rbac".content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = {
          name = "vector";
          labels = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
            "app.kubernetes.io/version" = "0.51.0-distroless-libc";
          };
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [
              "namespaces"
              "nodes"
              "pods"
            ];
            verbs = [
              "list"
              "watch"
            ];
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "vector";
          labels = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
            "app.kubernetes.io/version" = "0.51.0-distroless-libc";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "vector";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "vector";
            namespace = "monitoring";
          }
        ];
      }
    ];
  };
}
