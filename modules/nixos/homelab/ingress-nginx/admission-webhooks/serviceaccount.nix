{ ... }:
{
  services.k3s.manifests.ingress-nginx-admission-serviceaccount.content = [
    {
      apiVersion = "v1";
      kind = "ServiceAccount";
      metadata = {
        name = "ingress-nginx-admission";
        namespace = "ingress-nginx";
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/component" = "admission-webhook";
        };
      };
      automountServiceAccountToken = true;
    }
  ];
}
