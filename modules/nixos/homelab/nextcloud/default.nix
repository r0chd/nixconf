{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.nextcloud;
  inherit (lib) types;
in
{
  imports = [ ./db.nix ];

  options.homelab.nextcloud = {
    enable = lib.mkEnableOption "nextcloud";
    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.nextcloud.gated then
            "nextcloud.i.${config.homelab.domain}"
          else
            "nextcloud.${config.homelab.domain}"
        else
          null;
      description = "Hostname for nextcloud ingress (defaults to nextcloud.i.<domain> if gated, nextcloud.<domain> otherwise)";
    };

    admin = {
      username = lib.mkOption {
        type = types.str;
      };
      password = lib.mkOption {
        type = types.str;
      };
    };

    s3 = {
      region = lib.mkOption {
        default = config.homelab.garage.s3Region;
        type = types.str;
      };
      bucket = lib.mkOption {
        type = types.str;
        default = "nextcloud";
      };
    };
  };

  config.services.k3s = lib.mkIf cfg.enable {
    autoDeployCharts.nextcloud = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://nextcloud.github.io/helm/";
        chart = "nextcloud";
        version = "8.5.9";
        chartHash = "sha256-NfgY9InaoB9JTNQuud6yfwRFRQhAdECNHAWI+kaSbjM=";
      };
      targetNamespace = "nextcloud";
      createNamespace = true;

      values = {
        configs."logging.config.php" = ''
          <?php  
          $CONFIG = array (  
            'loglevel' => 3,  
          );
        '';

        replicaCount = 1;

        ingress =
          if cfg.ingressHost != null then
            {
              enabled = true;
              className = "nginx";
              annotations = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/";
              }
              // lib.optionalAttrs config.homelab.cert-manager.enable {
                "cert-manager.io/cluster-issuer" = "letsencrypt";
              }
              // lib.optionalAttrs cfg.gated {
                "nginx.ingress.kubernetes.io/auth-signin" =
                  "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
              };
              path = "/";
              pathType = "Prefix";

              tls = [
                {
                  secretName = "nextcloud-tls";
                  hosts = [ cfg.ingressHost ];
                }
              ];
            }
          else
            { };

        nextcloud = {
          host = cfg.ingressHost;
          trustedDomains = [
            cfg.ingressHost
            "nextcloud.nextcloud.svc.cluster.local"
          ];
          existingSecret = {
            enabled = true;
            secretName = "nextcloud-admin-credentials";
            usernameKey = "username";
            passwordKey = "password";
            tokenKey = "";
            smtpUsernameKey = "";
            smtpPasswordKey = "";
            smtpHostKey = "";
          };
          mail = {
            enabled = false;
            fromAddress = "user";
            domain = "domain.com";
            smtp = {
              host = "domain.com";
              secure = "ssl";
              port = 465;
              authtype = "LOGIN";
              name = "user";
              password = "pass";
            };
          };
          objectStore.s3 = {
            enabled = true;
            ssl = true;
            port = "443";
            inherit (cfg.s3) region;
            inherit (cfg.s3) bucket;
            host = "s3.${config.homelab.garage.ingressHost}";
            usePathStyle = true;
            storageClass = "STANDARD";
            existingSecret = "nextcloud-s3-credentials";
            secretKeys = {
              accessKey = "access_key_id";
              secretKey = "secret_access_key";
            };
          };
        };

        internalDatabase.enabled = false;
        externalDatabase = {
          enabled = true;
          type = "postgresql";
          host = "nextcloud-db-rw.nextcloud:5432";
          database = "app";
          existingSecret = {
            enabled = true;
            secretName = "nextcloud-db-app";
            usernameKey = "username";
            passwordKey = "password";
            databaseKey = "dbname";
          };
        };

        externalRedis = {
          enabled = true;
          host = "nextcloud-dragonfly.nextcloud.svc.cluster.local";
          port = "6379";
        };

        cronjob = {
          enabled = true;
          type = "sidecar";
          cronjob.schedule = "*/5 * * * *";
        };

        imaginary = {
          enabled = true;
          replicaCount = 1;
        };

        metrics = {
          enabled = true;
          replicaCount = 1;
          https = true;
          timeout = "5s";
          tlsSkipVerify = false;
          info = {
            apps = true;
            update = true;
          };
          serviceMonitor = {
            enabled = true;
            interval = "30s";
            scrapeTimeout = "10s";
          };
          rules = {
            enabled = true;
            defaults.enabled = true;
          };
        };

        persistence = {
          enabled = true;
          storageClass = config.homelab.storageClass;
        };
      };
    };

    manifests.nextcloud-dragonfly.content = {
      apiVersion = "dragonflydb.io/v1alpha1";
      kind = "Dragonfly";
      metadata = {
        name = "nextcloud-dragonfly";
        namespace = "nextcloud";
      };
      spec = {
        replicas = 1;
        args = [
          "--proactor_threads=1"
        ];
        resources = {
          requests = {
            cpu = "500m";
            memory = "256Mi";
          };
          limits = {
            memory = "384Mi";
          };
        };
      };
    };

    secrets = [
      {
        metadata = {
          name = "nextcloud-admin-credentials";
          namespace = "nextcloud";
        };
        stringData = {
          inherit (cfg.admin) username;
          inherit (cfg.admin) password;
        };
      }
    ];
  };
}
