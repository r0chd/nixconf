_:
{
  services.k3s.manifests.ingress-nginx-namespace.content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata = {
        labels = {
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/name" = "ingress-nginx";
        };
        name = "ingress-nginx";
      };
    }
  ];
}
