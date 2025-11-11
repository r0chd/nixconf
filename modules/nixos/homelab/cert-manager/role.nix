_:
{
  services.k3s.manifests."cert-manager-service-account".content = [
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "cert-manager-cainjector:leaderelection";
        namespace = "kube-system";
        labels = {
          app = "cainjector";
          "app.kubernetes.io/name" = "cainjector";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "cainjector";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      rules = [
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          resourceNames = [
            "cert-manager-cainjector-leader-election"
            "cert-manager-cainjector-leader-election-core"
          ];
          verbs = [
            "get"
            "update"
            "patch"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [ "create" ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "cert-manager:leaderelection";
        namespace = "kube-system";
        labels = {
          app = "cert-manager";
          "app.kubernetes.io/name" = "cert-manager";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      rules = [
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          resourceNames = [ "cert-manager-controller" ];
          verbs = [
            "get"
            "update"
            "patch"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [ "create" ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "cert-manager-webhook:dynamic-serving";
        namespace = "cert-manager";
        labels = {
          app = "webhook";
          "app.kubernetes.io/name" = "webhook";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "webhook";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      rules = [
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          resourceNames = [ "cert-manager-webhook-ca" ];
          verbs = [
            "get"
            "list"
            "watch"
            "update"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          verbs = [ "create" ];
        }
      ];
    }
  ];
}
