{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.kube-ops.enable) {
    services.k3s.manifests."kube-ops-rbac".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "kube-ops";
          namespace = "monitoring";
        };
      }
      {
        kind = "ClusterRole";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "kube-ops";
          namespace = "monitoring";
        };
        rules = [
          {
            apiGroups = [ "*" ];
            resources = [ "*" ];
            verbs = [
              "list"
              "get"
            ];
          }
          {
            nonResourceURLs = [ "*" ];
            verbs = [
              "list"
              "get"
            ];
          }
        ];
      }
      {
        kind = "ClusterRoleBinding";
        apiVersion = "rbac.authorization.k8s.io/v1";

        metadata = {
          name = "kube-ops";
          namespace = "monitoring";
        };

        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "kube-ops";
        };

        subjects = [
          {
            kind = "ServiceAccount";
            name = "kube-ops";
            namespace = "monitoring";
          }
        ];
      }
    ];
  };
}
