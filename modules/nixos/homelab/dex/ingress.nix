{ config, lib, ... }:
let
  cfg = config.homelab.dex;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests."dex-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "dex-ingress";
          namespace = "dex";
          annotations = {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          };
        };
        spec = {
          tls = [
            {
              hosts = [ cfg.ingressHost ];
              secretName = "dex-tls";
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
                        name = "dex";
                        port = {
                          number = 5556;
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
