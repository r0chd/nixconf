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
        };
        spec = {
          selector.app = "garage";
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
