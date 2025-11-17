{ ... }:
{
  services.k3s.manifests.flux-apps.content = [
    {
      apiVersion = "source.toolkit.fluxcd.io/v1beta2";
      kind = "GitRepository";
      metadata = {
        name = "flux-system";
        namespace = "flux-system";
      };
      spec = {
        interval = "1m";
        url = "git://127.0.0.1:9418/flux";
        branch = "main";
      };
    }
  ];
}
