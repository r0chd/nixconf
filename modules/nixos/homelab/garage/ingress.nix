{ lib, config, ... }:
let
  cfg = config.homelab.garage;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable && cfg.ingressHost != null) {
    services.k3s.manifests.garage-ingress.content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "garage-ingress";
          namespace = "default";
          labels = {
            "app.kubernetes.io/name" = "garage";
          };
          annotations = lib.optionalAttrs config.homelab.cert-manager.enable {
            "cert-manager.io/cluster-issuer" = "letsencrypt";
          }
          // {
            "nginx.ingress.kubernetes.io/proxy-body-size" = "0";
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
              hosts = [
                "s3.${cfg.ingressHost}"
                "admin.${cfg.ingressHost}"
              ];
              secretName = "garage-tls";
            }
          ];
          rules = [
            {
              host = "s3.${cfg.ingressHost}";
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "garage-s3";
                        port.number = 3900;
                      };
                    };
                  }
                ];
              };
            }
            {
              host = "admin.${cfg.ingressHost}";
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "garage-admin";
                        port.number = 3902;
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
