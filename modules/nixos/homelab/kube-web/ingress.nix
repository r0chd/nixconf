{ lib, config, ... }:
let
  cfg = config.homelab.kube-web;
in
{
  config = lib.mkIf (config.homelab.enable && config.homelab.kube-web.enable) {
    services.k3s.manifests."kube-web-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "kube-web-ingress";
          namespace = "monitoring";
        };
        spec = {
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
