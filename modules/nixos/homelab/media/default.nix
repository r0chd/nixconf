{ lib, config, ... }:
let
  cfg = config.homelab.media.servarr;
  inherit (lib) types;
in
{
  options.homelab.media = {
    enable = lib.mkEnableOption "servarr stack";

    servarr = {
      radarr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.radarr.gated then
                "radarr.i.${config.homelab.domain}"
              else
                "radarr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for radarr ingress (defaults to radarr.i.<domain> if gated, radarr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for radarr container.";
        };
        apiKey = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "API key for radarr (if null, will be auto-generated)";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for radarr config volume";
        };
      };

      sonarr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.sonarr.gated then
                "sonarr.i.${config.homelab.domain}"
              else
                "sonarr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for sonarr ingress (defaults to sonarr.i.<domain> if gated, sonarr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for sonarr container.";
        };
        apiKey = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "API key for sonarr (if null, will be auto-generated)";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for sonarr config volume";
        };
      };

      lidarr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.lidarr.gated then
                "lidarr.i.${config.homelab.domain}"
              else
                "lidarr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for lidarr ingress (defaults to lidarr.i.<domain> if gated, lidarr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for lidarr container.";
        };
        apiKey = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "API key for lidarr (if null, will be auto-generated)";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for lidarr config volume";
        };
      };

      readarr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.readarr.gated then
                "readarr.i.${config.homelab.domain}"
              else
                "readarr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for readarr ingress (defaults to readarr.i.<domain> if gated, readarr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for readarr container.";
        };
        apiKey = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "API key for readarr (if null, will be auto-generated)";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for readarr config volume";
        };
      };

      prowlarr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.prowlarr.gated then
                "prowlarr.i.${config.homelab.domain}"
              else
                "prowlarr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for prowlarr ingress (defaults to prowlarr.i.<domain> if gated, prowlarr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for prowlarr container.";
        };
        apiKey = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "API key for prowlarr (if null, will be auto-generated)";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for prowlarr config volume";
        };
      };

      bazarr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.bazarr.gated then
                "bazarr.i.${config.homelab.domain}"
              else
                "bazarr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for bazarr ingress (defaults to bazarr.i.<domain> if gated, bazarr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for bazarr container.";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for bazarr config volume";
        };
      };

      jellyseerr = {
        gated = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Whether to gate this service behind oauth2-proxy";
        };
        ingressHost = lib.mkOption {
          type = types.nullOr types.str;
          default =
            if config.homelab.domain != null then
              if cfg.jellyseerr.gated then
                "jellyseerr.i.${config.homelab.domain}"
              else
                "jellyseerr.${config.homelab.domain}"
            else
              null;
          description = "Hostname for jellyseerr ingress (defaults to jellyseerr.i.<domain> if gated, jellyseerr.<domain> otherwise)";
        };
        resources = lib.mkOption {
          type = types.attrsOf (types.attrsOf (types.nullOr types.str));
          default = { };
          description = "Kubernetes resource requests/limits for jellyseerr container.";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "500Mi";
          description = "Storage size for jellyseerr config volume";
        };
      };

      storage = {
        mediaVolumeSize = lib.mkOption {
          type = types.str;
          default = "250Gi";
          description = "Storage size for shared media volume";
        };
        downloadsVolumeSize = lib.mkOption {
          type = types.str;
          default = "100Gi";
          description = "Storage size for downloads volume";
        };
        storageClassName = lib.mkOption {
          type = types.str;
          default = config.homelab.storageClass;
          description = "Storage class name for servarr volumes";
        };
      };
    };
  };

  config.services.k3s = lib.mkIf config.homelab.media.enable {
    autoDeployCharts.servarr = {
      name = "servarr";
      repo = "oci://ghcr.io/fonzdm/servarr/servarr";
      version = "1.0.2";
      hash = "sha256-bDW/o15coCO1iys5fw87zyXTLDK5mtfnii09121tvJk=";
      targetNamespace = "media";
      values = {
        global = {
          apikey = "";
          storageClassName = cfg.storage.storageClassName;
          ingressClassName = "nginx";
          certManagerClusterIssuer = if config.homelab.cert-manager.enable then "letsencrypt" else "";
        };
        metrics = {
          enabled = true;
        };
        initJellyseerr = true;
        volumes = {
          storageClass = cfg.storage.storageClassName;
          downloads = {
            name = "downloads-volume";
            size = cfg.storage.downloadsVolumeSize;
          };
          media = {
            name = "media-volume";
            size = cfg.storage.mediaVolumeSize;
          };
          torrentConfig = {
            name = "torrent-config";
            size = "250Mi";
          };
        };
        radarr = {
          enabled = true;
          metrics = {
            main = {
              enabled = false;
            };
          };
          workload = {
            main = {
              podSpec = {
                containers = {
                  main = {
                    env = if cfg.radarr.apiKey != null then {
                      RADARR__API_KEY = cfg.radarr.apiKey;
                    } else { };
                    resources = cfg.radarr.resources;
                  };
                };
              };
            };
          };
          ingress = lib.mkIf (cfg.radarr.ingressHost != null) {
            radarr-ing = {
              enabled = true;
              primary = true;
              required = true;
              expandObjectName = false;
              annotations = {
                "cert-manager.io/cluster-issuer" = if config.homelab.cert-manager.enable then "letsencrypt" else "";
              }
              // lib.optionalAttrs cfg.radarr.gated {
                "nginx.ingress.kubernetes.io/auth-signin" =
                  "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
              };
              ingressClassName = "nginx";
              hosts = [
                {
                  host = cfg.radarr.ingressHost;
                  paths = [
                    {
                      path = "/";
                      pathType = "Prefix";
                    }
                  ];
                }
              ];
              tls = [
                {
                  hosts = [ cfg.radarr.ingressHost ];
                  secretName = "radarr-tls";
                }
              ];
              integrations = {
                certManager = {
                  enabled = config.homelab.cert-manager.enable;
                };
                traefik = {
                  enabled = false;
                };
              };
            };
          };
          persistence = {
            config = {
              enabled = true;
              type = "pvc";
              size = cfg.radarr.storageSize;
              accessModes = "ReadWriteMany";
              storageClass = cfg.storage.storageClassName;
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/config";
                  };
                };
                exportarr = {
                  exportarr = {
                    mountPath = "/config";
                    readOnly = true;
                  };
                };
              };
            };
            media = {
              enabled = true;
              type = "pvc";
              existingClaim = "media-volume";
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/mnt/media";
                  };
                };
              };
            };
            downloads = {
              enabled = true;
              type = "pvc";
              existingClaim = "downloads-volume";
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/mnt/downloads";
                  };
                };
              };
            };
          };
        };
        sonarr = {
          enabled = true;
          metrics = {
            main = {
              enabled = false;
            };
          };
          workload = {
            main = {
              podSpec = {
                containers = {
                  main = {
                    env = if cfg.sonarr.apiKey != null then {
                      SONARR__API_KEY = cfg.sonarr.apiKey;
                    } else { };
                    resources = cfg.sonarr.resources;
                  };
                };
              };
            };
          };
          ingress = lib.mkIf (cfg.sonarr.ingressHost != null) {
            sonarr-ing = {
              enabled = true;
              primary = true;
              required = true;
              expandObjectName = false;
              annotations = {
                "cert-manager.io/cluster-issuer" = if config.homelab.cert-manager.enable then "letsencrypt" else "";
              }
              // lib.optionalAttrs cfg.sonarr.gated {
                "nginx.ingress.kubernetes.io/auth-signin" =
                  "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
              };
              ingressClassName = "nginx";
              hosts = [
                {
                  host = cfg.sonarr.ingressHost;
                  paths = [
                    {
                      path = "/";
                      pathType = "Prefix";
                    }
                  ];
                }
              ];
              tls = [
                {
                  hosts = [ cfg.sonarr.ingressHost ];
                  secretName = "sonarr-tls";
                }
              ];
              integrations = {
                certManager = {
                  enabled = config.homelab.cert-manager.enable;
                };
              };
            };
          };
          persistence = {
            config = {
              enabled = true;
              type = "pvc";
              size = cfg.sonarr.storageSize;
              accessModes = "ReadWriteMany";
              storageClass = cfg.storage.storageClassName;
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/config";
                  };
                };
                exportarr = {
                  exportarr = {
                    mountPath = "/config";
                    readOnly = true;
                  };
                };
              };
            };
            media = {
              enabled = true;
              type = "pvc";
              existingClaim = "media-volume";
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/mnt/media";
                  };
                };
              };
            };
            downloads = {
              enabled = true;
              type = "pvc";
              existingClaim = "downloads-volume";
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/mnt/downloads";
                  };
                };
              };
            };
          };
        };
        prowlarr = {
          enabled = true;
          metrics = {
            main = {
              enabled = false;
            };
          };
          workload = {
            main = {
              podSpec = {
                containers = {
                  main = {
                    env = if cfg.prowlarr.apiKey != null then {
                      PROWLARR__API_KEY = cfg.prowlarr.apiKey;
                    } else { };
                    resources = cfg.prowlarr.resources;
                  };
                };
              };
            };
          };
          ingress = lib.mkIf (cfg.prowlarr.ingressHost != null) {
            prowlarr-ing = {
              enabled = true;
              primary = true;
              required = true;
              expandObjectName = false;
              annotations = {
                "cert-manager.io/cluster-issuer" = if config.homelab.cert-manager.enable then "letsencrypt" else "";
              }
              // lib.optionalAttrs cfg.prowlarr.gated {
                "nginx.ingress.kubernetes.io/auth-signin" =
                  "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
              };
              ingressClassName = "nginx";
              hosts = [
                {
                  host = cfg.prowlarr.ingressHost;
                  paths = [
                    {
                      path = "/";
                      pathType = "Prefix";
                    }
                  ];
                }
              ];
              tls = [
                {
                  hosts = [ cfg.prowlarr.ingressHost ];
                  secretName = "prowlarr-tls";
                }
              ];
              integrations = {
                certManager = {
                  enabled = config.homelab.cert-manager.enable;
                };
                traefik = {
                  enabled = false;
                };
              };
            };
          };
          persistence = {
            config = {
              enabled = true;
              type = "pvc";
              size = cfg.prowlarr.storageSize;
              accessModes = "ReadWriteMany";
              storageClass = cfg.storage.storageClassName;
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/config";
                  };
                };
                exportarr = {
                  exportarr = {
                    mountPath = "/config";
                    readOnly = true;
                  };
                };
              };
            };
          };
        };
        jellyseerr = {
          enabled = true;
          metrics = {
            main = {
              enabled = false;
            };
          };
          ingress = lib.mkIf (cfg.jellyseerr.ingressHost != null) {
            jellyseerr-ing = {
              enabled = true;
              primary = true;
              required = true;
              expandObjectName = false;
              annotations = {
                "cert-manager.io/cluster-issuer" = if config.homelab.cert-manager.enable then "letsencrypt" else "";
              }
              // lib.optionalAttrs cfg.jellyseerr.gated {
                "nginx.ingress.kubernetes.io/auth-signin" =
                  "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
              };
              ingressClassName = "nginx";
              hosts = [
                {
                  host = cfg.jellyseerr.ingressHost;
                  paths = [
                    {
                      path = "/";
                      pathType = "Prefix";
                    }
                  ];
                }
              ];
              tls = [
                {
                  hosts = [ cfg.jellyseerr.ingressHost ];
                  secretName = "jellyseerr-tls";
                }
              ];
              integrations = {
                certManager = {
                  enabled = config.homelab.cert-manager.enable;
                };
                traefik = {
                  enabled = false;
                };
              };
            };
          };
          persistence = {
            config = {
              enabled = true;
              type = "pvc";
              size = cfg.jellyseerr.storageSize;
              accessModes = "ReadWriteMany";
              storageClass = cfg.storage.storageClassName;
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/app/config";
                  };
                };
                exportarr = {
                  exportarr = {
                    mountPath = "/config";
                    readOnly = true;
                  };
                };
              };
            };
            media = {
              enabled = true;
              type = "pvc";
              existingClaim = "media-volume";
              targetSelector = {
                main = {
                  main = {
                    mountPath = "/mnt/media";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
