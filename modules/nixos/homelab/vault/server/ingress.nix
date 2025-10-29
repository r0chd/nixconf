{ ... }:
{
  services.k3s.manifests."vault-server-ingress".content = [
    {
      apiVersion = "extensions/v1beta1";
    }
  ];
}
