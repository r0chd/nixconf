{ ... }:
{
  services.k3s.manifests."metallb-secret".content = [
    {
      apiVersion = "v1";
      kind = "Secret";
      metadata = {
        name = "metallb-webhook-cert";
        namespace = "default";
        labels = {
          "app.kubernetes.io/name" = "metallb";
          "app.kubernetes.io/instance" = "metallb";
          "app.kubernetes.io/version" = "v0.15.2";
        };
      };
    }
  ];
}
