{ ... }:
{
  services.k3s.manifests."metallb-service".content = [
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        name = "metallb-webhook-service";
        namespace = "default";
        labels = {
          "app.kubernetes.io/name" = "metallb";
          "app.kubernetes.io/instance" = "metallb";
          "app.kubernetes.io/version" = "v0.15.2";
        };
      };
      spec = {
        ports = [
          {
            port = 443;
            targetPort = 9443;
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "metallb";
          "app.kubernetes.io/instance" = "metallb";
          "app.kubernetes.io/component" = "controller";
        };
      };
    }
  ];
}
