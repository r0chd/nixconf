{ lib, config, ... }:
let
  cfg = config.homelab.forgejo;
  inherit (lib) types;
in
{
  imports = [ ./db.nix ];

  options.homelab.forgejo = {
    enable = lib.mkEnableOption "forgejo";
    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.forgejo.gated then
            "forgejo.i.${config.homelab.domain}"
          else
            "forgejo.${config.homelab.domain}"
        else
          null;
      description = "Hostname for forgejo ingress (defaults to forgejo.i.<domain> if gated, forgejo.<domain> otherwise)";
    };
    admin = {
      username = lib.mkOption {
        type = types.str;
      };
      password = lib.mkOption {
        type = types.str;
      };
      email = lib.mkOption {
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
        default = "forgejo";
      };
      access_key_id = lib.mkOption {
        type = types.str;
      };
      secret_access_key = lib.mkOption {
        type = types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      autoDeployCharts.forgejo = {
        name = "forgejo";
        repo = "oci://code.forgejo.org/forgejo-helm/forgejo";
        version = "15.0.2";
        hash = "sha256-1ATEsGDmEgYZvIJG50zENb3d0MoL3fPd/i5OR8zuxdc=";
        targetNamespace = "forgejo";
        createNamespace = true;

        values = {
          replicaCount = 1;

          service = {
            ssh = {
              type = "NodePort";
              nodePort = 30988;
            };
            http = {
              type = "ClusterIP";
            };
          };

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
                    secretName = "forgejo-tls";
                    hosts = [ cfg.ingressHost ];
                  }
                ];
              }
            else
              { };

          persistence = {
            enabled = true;
            create = true;
            mount = true;
            claimName = "gitea-shared-storage";
            size = "1Gi";
            accessModes = [ "ReadWriteOnce" ];
            labels = { };
            storageClass = null;
            subPath = null;
            volumeName = "";
            annotations = {
              "helm.sh/resource-policy" = "keep";
            };
          };

          initContainers = {
            resources = {
              limits = { };
              requests = {
                cpu = "100m";
                memory = "128Mi";
              };
            };
          };

          signing = {
            enabled = false;
            gpgHome = "/data/git/.gnupg";
            privateKey = "";
            existingSecret = "";
          };

          gitea = {
            admin = {
              existingSecret = "forgejo-admin";
              inherit (cfg.admin) email;
              passwordMode = "keepUpdated";
            };
            metrics.enabled = true;
            additionalConfigFromEnvs = [
              {
                name = "FORGEJO__database__DB_TYPE";
                value = "postgres";
              }
              {
                name = "FORGEJO__database__HOST";
                valueFrom.secretKeyRef = {
                  name = "forgejo-db-app";
                  key = "host";
                };
              }
              {
                name = "FORGEJO__database__NAME";
                valueFrom.secretKeyRef = {
                  name = "forgejo-db-app";
                  key = "dbname";
                };
              }
              {
                name = "FORGEJO__database__USER";
                valueFrom.secretKeyRef = {
                  name = "forgejo-db-app";
                  key = "username";
                };
              }
              {
                name = "FORGEJO__database__PASSWD";
                valueFrom.secretKeyRef = {
                  name = "forgejo-db-app";
                  key = "password";
                };
              }
              {
                name = "FORGEJO__storage__MINIO_ACCESS_KEY_ID";
                valueFrom.secretKeyRef = {
                  name = "forgejo-s3-credentials";
                  key = "access_key_id";
                };
              }
              {
                name = "FORGEJO__storage__MINIO_SECRET_ACCESS_KEY";
                valueFrom.secretKeyRef = {
                  name = "forgejo-s3-credentials";
                  key = "secret_access_key";
                };
              }
            ];
            ssh = {
              logLevel = "INFO";
            };
            config = {
              SSH_PORT = 30988;
              APP_NAME = "Forgejo: Beyond coding. We forge.";
              RUN_MODE = "prod";

              service = {
                DEFAULT_ALLOW_CREATE_ORGANIZATION = false;
              };
              repository = {
                MAX_CREATION_LIMIT = 0;
              };

              storage = {
                STORAGE_TYPE = "minio";
                MINIO_ENDPOINT = "s3.${config.homelab.garage.ingressHost}";
                MINIO_BUCKET = cfg.s3.bucket;
                MINIO_USE_SSL = true;
                MINIO_FORCE_PATH_STYLE = true;
                MINIO_LOCATION = cfg.s3.region;
              };
              queue = {
                TYPE = "redis";
                CONN_STR = "redis://forgejo-dragonfly.forgejo.svc.cluster.local:6379";
              };
              cache = {
                ADAPTER = "redis";
                HOST = "redis://forgejo-dragonfly.forgejo.svc.cluster.local:6379";
              };
              session = {
                PROVIDER = "redis";
                PROVIDER_CONFIG = "redis://forgejo-dragonfly.forgejo.svc.cluster.local:6379";
              };

            };
          };
        };
      };

      manifests.forgejo-dragonfly.content = {
        apiVersion = "dragonflydb.io/v1alpha1";
        kind = "Dragonfly";
        metadata = {
          name = "forgejo-dragonfly";
          namespace = "forgejo";
        };
        spec = {
          replicas = 1;
          resources = {
            requests = {
              cpu = "500m";
              memory = "500Mi";
            };
            limits = {
              cpu = "600m";
              memory = "750Mi";
            };
          };
        };
      };

      secrets = [
        {
          metadata = {
            name = "forgejo-admin";
            namespace = "forgejo";
          };
          stringData = {
            inherit (cfg.admin) username;
            inherit (cfg.admin) password;
          };
        }
        {
          metadata = {
            name = "forgejo-s3-credentials";
            namespace = "forgejo";
          };
          stringData = {
            inherit (cfg.s3) access_key_id;
            inherit (cfg.s3) secret_access_key;
          };
        }
      ];
    };
  };
}
