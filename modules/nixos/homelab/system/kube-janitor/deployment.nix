{ ... }:
{
  services.k3s.manifests.kube-janitor-deployment.content = [
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "kube-janitor";
        namespace = "system";
      };
      spec = {
        replicas = 1;
        selector = {
          matchLabels = {
            "app.kubernetes.io/name" = "kube-janitor";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/name" = "kube-janitor";
            };
            annotations."reloader.stakater.com/auto" = "true";
          };
          spec = {
            serviceAccountName = "kube-janitor";
            containers = [
              {
                name = "kube-janitor";
                image = "ghcr.io/r0chd/kube-janitor:master-15eb071";
                imagePullPolicy = "IfNotPresent";
                args = [
                  "kube-janitor"
                  "--config"
                  "/app/config.yaml"
                ];
                volumeMounts = [
                  {
                    name = "config-volume";
                    mountPath = "/app/config.yaml";
                    subPath = "config.yaml";
                  }
                  {
                    name = "k3s-manifests";
                    mountPath = "/manifests";
                    readOnly = true;
                  }
                ];
              }
            ];
            volumes = [
              {
                name = "config-volume";
                configMap = {
                  name = "kube-janitor-config";
                };
              }
              {
                name = "k3s-manifests";
                hostPath = {
                  path = "/var/lib/kube-janitor";
                  type = "DirectoryOrCreate";
                };
              }
            ];
          };
        };
      };
    }
  ];
}
