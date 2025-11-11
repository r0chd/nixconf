_:
{
  services.k3s.manifests."cert-manager-namespace".content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata = {
        name = "cert-manager";
      };
    }
  ];
}
