{ ... }:
{
  services.k3s.manifests.ingress-nginx-ingressclass.content = [
    {
      apiVersion = "networking.k8s.io/v1";
      kind = "IngressClass";
      metadata = {
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/component" = "controller";
        };
        name = "nginx";
        annotations = {
          "ingressclass.kubernetes.io/is-default-class" = "true";
        };
      };
      spec = {
        controller = "k8s.io/ingress-nginx";
      };
    }
  ];
}
