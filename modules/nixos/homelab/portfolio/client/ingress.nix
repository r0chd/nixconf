{ config, lib, ... }:
let
  cfg = config.homelab.portfolio;
in
{
  config = lib.mkIf (config.homelab.enable && config.homelab.portfolio.enable) {
    services.k3s.manifests."portfolio-client-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "portfolio-client-ingress";
          namespace = "portfolio";
          annotations = {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          };
        };
        spec = {
          tls = [
            {
              hosts = [ cfg.ingressHost ];
              secretName = "portfolio-client-tls";
            }
          ];
          ingressClassName = "nginx";
          rules = [
            {
              host = cfg.ingressHost;
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "portfolio-client";
                        port = {
                          number = 80;
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
