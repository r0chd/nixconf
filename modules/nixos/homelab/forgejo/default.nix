{ lib, config, ... }:
let
  cfg = config.homelab.forgejo;
  inherit (lib) types;
in
{
  imports = [ ./db.nix ];

  options.homelab.forgejo = {
    enable = lib.mkEnableOption "forgejo";
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "forgejo.${config.homelab.domain}" else null;
      description = "Hostname for forgejo ingress (defaults to forgejo.<domain> if domain is set)";
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
          ingress =
            if cfg.ingressHost != null then
              {
                enabled = true;
                className = "nginx";
                annotations = {
                  "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                  "cert-manager.io/cluster-issuer" = "letsencrypt";
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
            size = "10Gi";
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
            ];
            ssh = {
              logLevel = "INFO";
            };
            config = {
              APP_NAME = "Forgejo: Beyond coding. We forge.";
              RUN_MODE = "prod";
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
              mirror = { };
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
            inherit (cfg.admin) email;
          };
        }
      ];
    };
  };
}
