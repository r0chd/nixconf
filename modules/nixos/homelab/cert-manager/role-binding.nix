{ config, lib, ... }:
let
  cfg = config.homelab.cert-manager;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."cert-manager-role-binding".content = [
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "RoleBinding";
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
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "cert-manager-cainjector:leaderelection";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "cert-manager-cainjector";
          namespace = "cert-manager";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "RoleBinding";
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
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "cert-manager:leaderelection";
      };
      subjects = [
        {
          apiGroup = "";
          kind = "ServiceAccount";
          name = "cert-manager";
          namespace = "cert-manager";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "RoleBinding";
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
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "cert-manager-webhook:dynamic-serving";
      };
      subjects = [
        {
          apiGroup = "";
          kind = "ServiceAccount";
          name = "cert-manager-webhook";
          namespace = "cert-manager";
        }
      ];
    }
  ];
  };
}
