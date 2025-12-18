{ ... }:
{
  services.k3s.manifests."auth-namespace".content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata = {
        name = "auth";
        labels = {
          "app.kubernetes.io/name" = "auth";
        };
      };
    }
  ];
}
