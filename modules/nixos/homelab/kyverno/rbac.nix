{ ... }:
{
  services.k3s.manifests."kyverno-rbac".content = [
    {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        name = "kyverno-admission-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      automountServiceAccountToken = false;
    }
    {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        name = "kyverno-background-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      automountServiceAccountToken = false;
    }
    {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        name = "kyverno-cleanup-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      automountServiceAccountToken = false;
    }
    {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        name = "kyverno-reports-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      automountServiceAccountToken = false;
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:admission-controller";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      aggregationRule = {
        clusterRoleSelectors = [
          {
            matchLabels = {
              "rbac.kyverno.io/aggregate-to-admission-controller" = "true";
            };
          }
          {
            matchLabels = {
              "app.kubernetes.io/component" = "admission-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
            };
          }
        ];
      };
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:admission-controller:core";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      rules = [
        {
          apiGroups = [ "apiextensions.k8s.io" ];
          resources = [ "customresourcedefinitions" ];
          verbs = [ "get" ];
        }
        {
          apiGroups = [ "admissionregistration.k8s.io" ];
          resources = [
            "mutatingwebhookconfigurations"
            "validatingwebhookconfigurations"
            "validatingadmissionpolicies"
            "validatingadmissionpolicybindings"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "rbac.authorization.k8s.io" ];
          resources = [
            "roles"
            "clusterroles"
            "rolebindings"
            "clusterrolebindings"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "policies"
            "policies/status"
            "clusterpolicies"
            "clusterpolicies/status"
            "updaterequests"
            "updaterequests/status"
            "globalcontextentries"
            "globalcontextentries/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [ "policyexceptions" ];
          verbs = [
            "create"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [
            "validatingpolicies"
            "validatingpolicies/status"
            "namespacedvalidatingpolicies"
            "namespacedvalidatingpolicies/status"
            "imagevalidatingpolicies"
            "imagevalidatingpolicies/status"
            "namespacedimagevalidatingpolicies"
            "namespacedimagevalidatingpolicies/status"
            "generatingpolicies"
            "generatingpolicies/status"
            "mutatingpolicies"
            "mutatingpolicies/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [ "policyexceptions" ];
          verbs = [
            "create"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
        {
          apiGroups = [ "reports.kyverno.io" ];
          resources = [
            "ephemeralreports"
            "clusterephemeralreports"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "wgpolicyk8s.io" ];
          resources = [
            "policyreports"
            "policyreports/status"
            "clusterpolicyreports"
            "clusterpolicyreports/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [
            ""
            "events.k8s.io"
          ];
          resources = [ "events" ];
          verbs = [
            "create"
            "update"
            "patch"
          ];
        }
        {
          apiGroups = [ "authorization.k8s.io" ];
          resources = [ "subjectaccessreviews" ];
          verbs = [ "create" ];
        }
        {
          apiGroups = [ "" ];
          resources = [
            "configmaps"
            "namespaces"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [
            "create"
            "update"
            "patch"
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:background-controller";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      aggregationRule = {
        clusterRoleSelectors = [
          {
            matchLabels = {
              "rbac.kyverno.io/aggregate-to-background-controller" = "true";
            };
          }
          {
            matchLabels = {
              "app.kubernetes.io/component" = "background-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
            };
          }
        ];
      };
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:background-controller:core";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      rules = [
        {
          apiGroups = [ "apiextensions.k8s.io" ];
          resources = [ "customresourcedefinitions" ];
          verbs = [ "get" ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "policies"
            "policies/status"
            "clusterpolicies"
            "clusterpolicies/status"
            "policyexceptions"
            "updaterequests"
            "updaterequests/status"
            "globalcontextentries"
            "globalcontextentries/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [
            "generatingpolicies"
            "mutatingpolicies"
            "policyexceptions"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [ "policyexceptions" ];
          verbs = [
            "create"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [
            "namespaces"
            "configmaps"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [
            ""
            "events.k8s.io"
          ];
          resources = [ "events" ];
          verbs = [
            "create"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
        {
          apiGroups = [ "reports.kyverno.io" ];
          resources = [
            "ephemeralreports"
            "clusterephemeralreports"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "networking.k8s.io" ];
          resources = [
            "ingresses"
            "ingressclasses"
            "networkpolicies"
          ];
          verbs = [
            "create"
            "update"
            "patch"
            "delete"
          ];
        }
        {
          apiGroups = [ "rbac.authorization.k8s.io" ];
          resources = [
            "rolebindings"
            "roles"
          ];
          verbs = [
            "create"
            "update"
            "patch"
            "delete"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [
            "configmaps"
            "resourcequotas"
            "limitranges"
          ];
          verbs = [
            "create"
            "update"
            "patch"
            "delete"
          ];
        }
        {
          apiGroups = [ "resource.k8s.io" ];
          resources = [
            "resourceclaims"
            "resourceclaimtemplates"
          ];
          verbs = [
            "create"
            "delete"
            "update"
            "patch"
            "deletecollection"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:cleanup-controller";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      aggregationRule = {
        clusterRoleSelectors = [
          {
            matchLabels = {
              "rbac.kyverno.io/aggregate-to-cleanup-controller" = "true";
            };
          }
          {
            matchLabels = {
              "app.kubernetes.io/component" = "cleanup-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
            };
          }
        ];
      };
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:cleanup-controller:core";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      rules = [
        {
          apiGroups = [ "apiextensions.k8s.io" ];
          resources = [ "customresourcedefinitions" ];
          verbs = [ "get" ];
        }
        {
          apiGroups = [ "admissionregistration.k8s.io" ];
          resources = [ "validatingwebhookconfigurations" ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "update"
            "watch"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "namespaces" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "clustercleanuppolicies"
            "cleanuppolicies"
          ];
          verbs = [
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [
            "deletingpolicies"
            "namespaceddeletingpolicies"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [
            "deletingpolicies/status"
            "namespaceddeletingpolicies/status"
          ];
          verbs = [ "update" ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [ "policyexceptions" ];
          verbs = [
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "globalcontextentries"
            "globalcontextentries/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "clustercleanuppolicies/status"
            "cleanuppolicies/status"
          ];
          verbs = [ "update" ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "configmaps" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [
            ""
            "events.k8s.io"
          ];
          resources = [ "events" ];
          verbs = [
            "create"
            "patch"
            "update"
          ];
        }
        {
          apiGroups = [ "authorization.k8s.io" ];
          resources = [ "subjectaccessreviews" ];
          verbs = [ "create" ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:admin:policies";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-admin" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "cleanuppolicies"
            "clustercleanuppolicies"
            "policies"
            "clusterpolicies"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:view:policies";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-view" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "cleanuppolicies"
            "clustercleanuppolicies"
            "policies"
            "clusterpolicies"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:admin:policyreports";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-admin" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "wgpolicyk8s.io" ];
          resources = [
            "policyreports"
            "clusterpolicyreports"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:view:policyreports";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-view" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "wgpolicyk8s.io" ];
          resources = [
            "policyreports"
            "clusterpolicyreports"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:admin:reports";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-admin" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "reports.kyverno.io" ];
          resources = [
            "ephemeralreports"
            "clusterephemeralreports"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:view:reports";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-view" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "reports.kyverno.io" ];
          resources = [
            "ephemeralreports"
            "clusterephemeralreports"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:admin:updaterequests";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-admin" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "kyverno.io" ];
          resources = [ "updaterequests" ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:rbac:view:updaterequests";
        labels = {
          "app.kubernetes.io/component" = "rbac";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
          "rbac.authorization.k8s.io/aggregate-to-view" = "true";
        };
      };
      rules = [
        {
          apiGroups = [ "kyverno.io" ];
          resources = [ "updaterequests" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:reports-controller";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      aggregationRule = {
        clusterRoleSelectors = [
          {
            matchLabels = {
              "rbac.kyverno.io/aggregate-to-reports-controller" = "true";
            };
          }
          {
            matchLabels = {
              "app.kubernetes.io/component" = "reports-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
            };
          }
        ];
      };
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "kyverno:reports-controller:core";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      rules = [
        {
          apiGroups = [ "apiextensions.k8s.io" ];
          resources = [ "customresourcedefinitions" ];
          verbs = [ "get" ];
        }
        {
          apiGroups = [ "" ];
          resources = [
            "configmaps"
            "namespaces"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "kyverno.io" ];
          resources = [
            "globalcontextentries"
            "globalcontextentries/status"
            "policyexceptions"
            "policies"
            "clusterpolicies"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [
            "validatingpolicies"
            "validatingpolicies/status"
            "namespacedvalidatingpolicies"
            "namespacedvalidatingpolicies/status"
            "imagevalidatingpolicies"
            "imagevalidatingpolicies/status"
            "namespacedimagevalidatingpolicies"
            "namespacedimagevalidatingpolicies/status"
            "generatingpolicies"
            "mutatingpolicies"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "policies.kyverno.io" ];
          resources = [
            "policyexceptions"
            "policyexceptions/status"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "admissionregistration.k8s.io" ];
          resources = [
            "validatingadmissionpolicies"
            "validatingadmissionpolicybindings"
          ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "reports.kyverno.io" ];
          resources = [
            "ephemeralreports"
            "clusterephemeralreports"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "wgpolicyk8s.io" ];
          resources = [
            "policyreports"
            "policyreports/status"
            "clusterpolicyreports"
            "clusterpolicyreports/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [ "openreports.io" ];
          resources = [
            "reports"
            "reports/status"
            "clusterreports"
            "clusterreports/status"
          ];
          verbs = [
            "create"
            "delete"
            "get"
            "list"
            "patch"
            "update"
            "watch"
            "deletecollection"
          ];
        }
        {
          apiGroups = [
            ""
            "events.k8s.io"
          ];
          resources = [ "events" ];
          verbs = [
            "create"
            "patch"
          ];
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:admission-controller";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "kyverno:admission-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-admission-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:admission-controller:view";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "view";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-admission-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:background-controller";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "kyverno:background-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-background-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:background-controller:view";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "view";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-background-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:cleanup-controller";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "kyverno:cleanup-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-cleanup-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:reports-controller";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "kyverno:reports-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-reports-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "ClusterRoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:reports-controller:view";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "ClusterRole";
        name = "view";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-reports-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "kyverno:admission-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      rules = [
        {
          apiGroups = [ "" ];
          resources = [
            "secrets"
            "serviceaccounts"
          ];
          verbs = [
            "get"
            "list"
            "watch"
            "patch"
            "create"
            "update"
            "delete"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "configmaps" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
          resourceNames = [
            "kyverno"
            "kyverno-metrics"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [
            "create"
            "delete"
            "get"
            "patch"
            "update"
          ];
        }
        {
          apiGroups = [ "apps" ];
          resources = [ "deployments" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "kyverno:background-controller";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
        namespace = "kyverno";
      };
      rules = [
        {
          apiGroups = [ "" ];
          resources = [ "configmaps" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
          resourceNames = [
            "kyverno"
            "kyverno-metrics"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [ "create" ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [
            "delete"
            "get"
            "patch"
            "update"
          ];
          resourceNames = [ "kyverno-background-controller" ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "kyverno:cleanup-controller";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
        namespace = "kyverno";
      };
      rules = [
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          verbs = [ "create" ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          verbs = [
            "delete"
            "get"
            "list"
            "update"
            "watch"
          ];
          resourceNames = [
            "kyverno-cleanup-controller.kyverno.svc.kyverno-tls-ca"
            "kyverno-cleanup-controller.kyverno.svc.kyverno-tls-pair"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "configmaps" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
          resourceNames = [
            "kyverno"
            "kyverno-metrics"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [ "create" ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [
            "delete"
            "get"
            "patch"
            "update"
          ];
          resourceNames = [ "kyverno-cleanup-controller" ];
        }
        {
          apiGroups = [ "apps" ];
          resources = [ "deployments" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
      ];
    }
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "Role";
      metadata = {
        name = "kyverno:reports-controller";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
        namespace = "kyverno";
      };
      rules = [
        {
          apiGroups = [ "" ];
          resources = [ "configmaps" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
          resourceNames = [
            "kyverno"
            "kyverno-metrics"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          verbs = [
            "get"
            "list"
            "watch"
          ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [ "create" ];
        }
        {
          apiGroups = [ "coordination.k8s.io" ];
          resources = [ "leases" ];
          verbs = [
            "delete"
            "get"
            "patch"
            "update"
          ];
          resourceNames = [ "kyverno-reports-controller" ];
        }
      ];
    }
    {
      kind = "RoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:admission-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "kyverno:admission-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-admission-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "RoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:background-controller";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
        namespace = "kyverno";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "kyverno:background-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-background-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "RoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:cleanup-controller";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
        namespace = "kyverno";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "kyverno:cleanup-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-cleanup-controller";
          namespace = "kyverno";
        }
      ];
    }
    {
      kind = "RoleBinding";
      apiVersion = "rbac.authorization.k8s.io/v1";
      metadata = {
        name = "kyverno:reports-controller";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
        namespace = "kyverno";
      };
      roleRef = {
        apiGroup = "rbac.authorization.k8s.io";
        kind = "Role";
        name = "kyverno:reports-controller";
      };
      subjects = [
        {
          kind = "ServiceAccount";
          name = "kyverno-reports-controller";
          namespace = "kyverno";
        }
      ];
    }
  ];
}
