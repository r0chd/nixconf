_:
{
  services.k3s.manifests."kyverno-namespace".content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata = {
        name = "kyverno";
        labels = {
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
    }
  ];
}
