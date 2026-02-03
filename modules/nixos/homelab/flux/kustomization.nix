{ ... }:
{
  services.k3s.manifests."flux-kustomization".content = [
    {
      apiVersion = "kustomize.toolkit.fluxcd.io/v1";
      kind = "Kustomization";
      metadata = {
        name = "flux-kustomization";
        namespace = "flux-system";
      };
      spec = {
        interval = "1m";
        path = "./";
        prune = true;
        sourceRef = {
          kind = "Bucket";
          name = "s3-bucket";
        };
      };
    }
  ];
}
