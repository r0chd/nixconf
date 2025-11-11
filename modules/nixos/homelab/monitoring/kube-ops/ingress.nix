{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.kube-ops;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests."kube-ops-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "kube-ops-ingress";
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
              secretName = "kube-ops-tls";
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
                        name = "kube-ops";
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
