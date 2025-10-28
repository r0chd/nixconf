{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.kube-web.enable) {
    services.k3s.manifests."kube-web-rbac".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "kube-web-view";
          namespace = "monitoring";
        };
      }
      {
        kind = "ClusterRole";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "kube-web-view";
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
          name = "kube-web-view";
          namespace = "monitoring";
        };

        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "kube-web-view";
        };

        subjects = [
          {
            kind = "ServiceAccount";
            name = "kube-web-view";
            namespace = "monitoring";
          }
        ];
      }
    ];
  };
}
