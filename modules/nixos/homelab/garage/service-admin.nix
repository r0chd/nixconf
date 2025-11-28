{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.garage.enable) {
    services.k3s.manifests.garage-service-admin.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "garage-admin";
          namespace = "default";
          labels = {
            "app.kubernetes.io/name" = "garage";
            "app.kubernetes.io/component" = "admin";
          };
        };
        spec = {
          selector."app.kubernetes.io/name" = "garage";
          ports = [
            {
              name = "admin";
              port = 3902;
              targetPort = 3902;
            }
          ];
        };
      }
    ];
  };
}
