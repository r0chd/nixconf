{ ... }:
{
  services.k3s.manifests.ingress-nginx-admission-job-patchWebhook.content = [
    {
      apiVersion = "batch/v1";
      kind = "Job";
      metadata = {
        name = "ingress-nginx-admission-patch";
        namespace = "ingress-nginx";
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/component" = "admission-webhook";
        };
      };
      spec = {
        ttlSecondsAfterFinished = 0;
        template = {
          metadata = {
            name = "ingress-nginx-admission-patch";
            labels = {
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/instance" = "ingress-nginx";
              "app.kubernetes.io/version" = "1.14.0";
              "app.kubernetes.io/part-of" = "ingress-nginx";
              "app.kubernetes.io/component" = "admission-webhook";
            };
          };
          spec = {
            containers = [
              {
                name = "patch";
                image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.6.4@sha256:bcfc926ed57831edf102d62c5c0e259572591df4796ef1420b87f9cf6092497f";
                imagePullPolicy = "IfNotPresent";
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
            restartPolicy = "OnFailure";
            serviceAccountName = "ingress-nginx-admission";
            automountServiceAccountToken = true;
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
          };
        };
      };
    }
  ];
}
