{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kuvasz;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."kuvasz-service".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "kuvasz-status";
          namespace = "monitoring";
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/status";
          };
        };
        spec = {
          rules = [
            {
              http = {
                paths = [
                  {
                    path = "/status";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "kuvasz";
                        port = {
                          number = 8080;
                        };
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
