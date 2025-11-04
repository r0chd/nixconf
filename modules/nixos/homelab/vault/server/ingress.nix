{ lib, config, ... }:
let
  cfg = config.homelab.vault;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests."vault-server-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "vault";
          namespace = "vault";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
          annotations = {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          };
        };
        spec = {
          ingressClassName = "nginx";
          tls = [
            {
              hosts = [ cfg.ingressHost ];
              secretName = "vault-tls";
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
                        name = "vault";
                        port.number = 8200;
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
