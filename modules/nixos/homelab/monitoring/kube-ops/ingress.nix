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
          labels = {
            "app.kubernetes.io/name" = "kube-ops";
          };
          annotations = lib.optionalAttrs config.homelab.cert-manager.enable {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          }
          // lib.optionalAttrs cfg.gated {
            "nginx.ingress.kubernetes.io/auth-signin" =
              "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
            "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
            "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
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
