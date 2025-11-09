{ ... }:
{
  services.k3s.manifests.ingress-nginx-configmap.content = [
    {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata = {
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/component" = "controller";
        };
        name = "ingress-nginx-controller";
        namespace = "ingress-nginx";
      };
      data = null;
    }
  ];
}
