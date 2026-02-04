{ config, lib, ... }:
let
  cfg = config.homelab.attic;
in
{
  config = lib.mkIf (cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests.attic-ingress.content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "attic-ingress";
          namespace = "attic";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
          annotations = lib.optionalAttrs config.homelab.cert-manager.enable {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          } // {
            "nginx.ingress.kubernetes.io/proxy-body-size" = "0";
          };
        };
        spec = {
          tls = [
            {
              hosts = [ cfg.ingressHost ];
              secretName = "attic-tls";
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
                        name = "attic-server";
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
