{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.garage.enable) {
    services.k3s.manifests.garage-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "garage";
          namespace = "default";
          labels = {
            "app.kubernetes.io/name" = "garage";
          };
        };
        spec = {
          clusterIP = "None";
          selector."app.kubernetes.io/name" = "garage";
          ports = [
            {
              name = "s3-api";
              port = 3900;
              targetPort = 3900;
            }
            {
              name = "rpc";
              port = 3901;
              targetPort = 3901;
            }
            {
              name = "admin";
              port = 3902;
              targetPort = 3902;
            }
            {
              name = "web";
              port = 3903;
              targetPort = 3903;
            }
          ];
        };
      }
    ];
  };
}
