{ config, lib, ... }:
let
  cfg = config.homelab.cert-manager;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."cert-manager-cluster-role-binding".content = [
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-cainjector";
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
        kind = "ClusterRole";
        name = "cert-manager-cainjector";
      };
      subjects = [
        {
          name = "cert-manager-cainjector";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-issuers";
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
        kind = "ClusterRole";
        name = "cert-manager-controller-issuers";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-clusterissuers";
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
        kind = "ClusterRole";
        name = "cert-manager-controller-clusterissuers";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-certificates";
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
        kind = "ClusterRole";
        name = "cert-manager-controller-certificates";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-orders";
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
        kind = "ClusterRole";
        name = "cert-manager-controller-orders";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-challenges";
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
        kind = "ClusterRole";
        name = "cert-manager-controller-challenges";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-ingress-shim";
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
        kind = "ClusterRole";
        name = "cert-manager-controller-ingress-shim";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-approve:cert-manager-io";
        labels = {
          app = "cert-manager";
          "app.kubernetes.io/name" = "cert-manager";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "cert-manager";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "cert-manager-controller-approve:cert-manager-io";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-controller-certificatesigningrequests";
        labels = {
          app = "cert-manager";
          "app.kubernetes.io/name" = "cert-manager";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "cert-manager";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "cert-manager-controller-certificatesigningrequests";
      };
      subjects = [
        {
          name = "cert-manager";
          namespace = "cert-manager";
          kind = "ServiceAccount";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRoleBinding";
      metadata = {
        name = "cert-manager-webhook:subjectaccessreviews";
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
        kind = "ClusterRole";
        name = "cert-manager-webhook:subjectaccessreviews";
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
