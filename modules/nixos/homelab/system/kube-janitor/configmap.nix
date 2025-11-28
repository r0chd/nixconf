{ ... }:
{
  services.k3s.manifests.kube-janitor-configmap.content = [
    {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata = {
        name = "kube-janitor-config";
        namespace = "system";
        labels = {
          "app.kubernetes.io/name" = "kube-janitor";
        };
      };
      data = {
        "config.yaml" = "directory: /manifests";
      };
    }
  ];
}
