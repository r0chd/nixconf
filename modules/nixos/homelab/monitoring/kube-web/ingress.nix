{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.kube-web;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests."kube-web-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "kube-web-ingress";
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
              secretName = "kube-web-tls";
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
                        name = "kube-web-view";
                        port.number = 80;
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
