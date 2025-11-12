{ ... }:
{
  services.k3s.manifests.ingress-nginx-job.content = [
    {
      apiVersion = "batch/v1";
      kind = "Job";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
        };
        name = "ingress-nginx-admission-create";
        namespace = "ingress-nginx";
      };
      spec = {
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "admission-webhook";
              "app.kubernetes.io/instance" = "ingress-nginx";
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/part-of" = "ingress-nginx";
              "app.kubernetes.io/version" = "1.14.0";
            };
            name = "ingress-nginx-admission-create";
          };
          spec = {
            automountServiceAccountToken = true;
            containers = [
              {
                args = [
                  "create"
                  "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc"
                  "--namespace=$(POD_NAMESPACE)"
                  "--secret-name=ingress-nginx-admission"
                ];
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                ];
                image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.6.4@sha256:bcfc926ed57831edf102d62c5c0e259572591df4796ef1420b87f9cf6092497f";
                imagePullPolicy = "IfNotPresent";
                name = "create";
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  readOnlyRootFilesystem = true;
                  runAsGroup = 65532;
                  runAsNonRoot = true;
                  runAsUser = 65532;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
              }
            ];
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
            restartPolicy = "OnFailure";
            serviceAccountName = "ingress-nginx-admission";
          };
        };
        ttlSecondsAfterFinished = 0;
      };
    }
    {
      apiVersion = "batch/v1";
      kind = "Job";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "admission-webhook";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
        };
        name = "ingress-nginx-admission-patch";
        namespace = "ingress-nginx";
      };
      spec = {
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "admission-webhook";
              "app.kubernetes.io/instance" = "ingress-nginx";
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/part-of" = "ingress-nginx";
              "app.kubernetes.io/version" = "1.14.0";
            };
            name = "ingress-nginx-admission-patch";
          };
          spec = {
            automountServiceAccountToken = true;
            containers = [
              {
                args = [
                  "patch"
                  "--webhook-name=ingress-nginx-admission"
                  "--namespace=$(POD_NAMESPACE)"
                  "--patch-mutating=false"
                  "--secret-name=ingress-nginx-admission"
                  "--patch-failure-policy=Fail"
                ];
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                ];
                image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.6.4@sha256:bcfc926ed57831edf102d62c5c0e259572591df4796ef1420b87f9cf6092497f";
                imagePullPolicy = "IfNotPresent";
                name = "patch";
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  readOnlyRootFilesystem = true;
                  runAsGroup = 65532;
                  runAsNonRoot = true;
                  runAsUser = 65532;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
              }
            ];
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
            restartPolicy = "OnFailure";
            serviceAccountName = "ingress-nginx-admission";
          };
        };
        ttlSecondsAfterFinished = 0;
      };
    }
  ];
}
