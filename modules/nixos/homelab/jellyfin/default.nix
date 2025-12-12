{ lib, config, ... }:
let
  cfg = config.homelab.jellyfin;
  inherit (lib) types;
in
{
  options.homelab.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.jellyfin.gated then
            "jellyfin.i.${config.homelab.domain}"
          else
            "jellyfin.${config.homelab.domain}"
        else
          null;
      description = "Hostname for jellyfin ingress (defaults to jellyfin.i.<domain> if gated, jellyfin.<domain> otherwise)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Resource requests/limits for jellyfin container.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      autoDeployCharts.jellyfin = {
        name = "jellyfin";
        repo = "https://utkuozdemir.org/helm-charts";
        version = "2.0.0";
        hash = "sha256-0qfOCdaTv1FUqWQqqJerSMwx8LRXs3hdpklQ14JkyfM=";
        targetNamespace = "jellyfin";
        createNamespace = true;

        values = {
          resources = cfg.resources;

          replicaCount = 1;
          hostNetwork = false;

          ingress =
            if cfg.ingressHost != null then
              {
                enabled = true;
                className = "nginx";
                annotations = {
                  "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                  "cert-manager.io/cluster-issuer" = "letsencrypt";
                }
                // lib.optionalAttrs cfg.gated {
                  "nginx.ingress.kubernetes.io/auth-signin" =
                    "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                  "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                  "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
                };
                hosts = [
                  {
                    host = cfg.ingressHost;
                    paths = [
                      {
                        path = "/";
                        pathType = "Prefix";
                        port = "http";
                      }
                    ];
                  }
                ];
                tls = [
                  {
                    secretName = "jellyfin-tls";
                    hosts = [ cfg.ingressHost ];
                  }
                ];
              }
            else
              { };

          persistence = {
            config = {
              enabled = true;
              isPvc = true;
              storageClass = config.homelab.storageClass;
              accessModes = [ "ReadWriteOnce" ];
              size = "2Gi";
              customVolume = { };
            };
            data = {
              enabled = true;
              isPvc = true;
              storageClass = config.homelab.storageClass;
              size = "20Gi";
            };
          };
        };
      };
    };
  };
}
