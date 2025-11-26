{ ... }:
{
  services.k3s.manifests.kube-janitor-configmap.content = [
    {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata = {
        name = "kube-janitor-config";
        namespace = "system";
      };
      data = {
        "config.yaml" = "directory: /manifests";
      };
    }
  ];
}
