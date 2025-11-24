_:
{
  services.k3s.manifests."flux-namespace".content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata.name = "flux-system";
    }
  ];
}
