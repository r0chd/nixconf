{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests."thanos-query-frontend-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "thanos-query-frontend-ingress";
          namespace = "monitoring";
          annotations = {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          };
        };
        spec = {
          ingressClassName = "nginx";
          tls = [
            {
              hosts = [ cfg.ingressHost ];
              secretName = "thanos-tls";
            }
          ];
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
                        name = "thanos-query-frontend";
                        port.number = 9090;
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


