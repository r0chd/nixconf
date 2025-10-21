{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.garage.enable) {
    services.k3s.manifests.garage-service-s3.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "garage-s3";
          namespace = "garage";
        };
        spec = {
          selector.app = "garage";
          ports = [
            {
              name = "s3-api";
              port = 3900;
              targetPort = 3900;
            }
          ];
        };
      }
    ];
  };
}
