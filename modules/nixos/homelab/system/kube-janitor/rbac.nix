{ ... }:
{
  services.k3s.manifests.kube-janitor-rbac.content = [
    {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        name = "kube-janitor";
        namespace = "system";
      };
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kube-janitor-role";
      };
      rules = [
        {
          apiGroups = [ "*" ];
          resources = [ "*" ];
          verbs = [
            "get"
            "list"
            "watch"
            "create"
            "update"
            "patch"
            "delete"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "kube-janitor-binding";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kube-janitor";
          namespace = "system";
        }
      ];
      roleRef = {
        kind = "ClusterRole";
        name = "kube-janitor-role";
        apiGroup = "rbac.authorization.k8s.io";
      };
    }
  ];
}
