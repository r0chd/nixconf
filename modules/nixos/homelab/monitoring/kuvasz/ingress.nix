{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kuvasz;
in
{
  config = lib.mkIf (cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests."kuvasz-ingress".content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "kuvasz-ingress";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "kuvasz";
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
          tls = [
            {
              hosts = [ cfg.ingressHost ];
              secretName = "kuvasz-tls";
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
                        name = "kuvasz";
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
