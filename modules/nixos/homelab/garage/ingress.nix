{ lib, config, ... }:
let
  cfg = config.homelab.garage;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests.garage-namespace.content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "garage-ingress";
          namespace = "garage";
        };
        spec = {
          ingressClassName = "nginx";
          rules = [
            {
              host = "s3.${cfg.ingressHost}";
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "garage-s3";
                        port.number = 3900;
                      };
                    };
                  }
                ];
              };
            }
            {
              host = "admin.${cfg.ingressHost}";
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "garage-admin";
                        port.number = 3902;
                      };
                    };
                  }
                ];
              };
            }
          ];
        };
      }
    ];
  };
}
