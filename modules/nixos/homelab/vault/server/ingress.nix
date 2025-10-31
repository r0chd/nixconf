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
        };
        spec = {
          ingressClassName = "nginx";
          rules = [
            {
              host = "vault.${cfg.ingressHost}";
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
