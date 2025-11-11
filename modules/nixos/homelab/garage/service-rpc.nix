{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.garage.enable) {
    services.k3s.manifests.garage-service-rpc.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "garage-rpc";
          namespace = "default";
        };
        spec = {
          clusterIP = "None";
          selector.app = "garage";
          ports = [
            {
              name = "rpc";
              port = 3901;
              targetPort = 3901;
            }
          ];
        };
      }
    ];
  };
}
