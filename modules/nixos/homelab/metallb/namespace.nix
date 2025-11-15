{ ... }:
{
  services.k3s.manifests."metallb-namespace".content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata.name = "metallb-system";
    }
  ];
}
