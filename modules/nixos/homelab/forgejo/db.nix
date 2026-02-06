{ config, lib, ... }:
let
  cfg = config.homelab.forgejo.db;
  inherit (lib) types;
in
{
  options.homelab.forgejo.db = {
    instances = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of PostgreSQL instances";
    };

    storageSize = lib.mkOption {
      type = types.str;
      default = "10Gi";
      description = "Storage size for the database";
    };

    walStorageSize = lib.mkOption {
      type = types.str;
      default = "2Gi";
      description = "WAL storage size";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits.";
    };

    backup.enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable database backups";
    };
  };

  config = lib.mkIf (config.homelab.enable && config.homelab.forgejo.enable) {
    services.k3s = {
      manifests.cnpg-databases.content = [
        {
          apiVersion = "networking.k8s.io/v1";
          kind = "NetworkPolicy";
          metadata = {
            name = "forgejo-db-allow-app";
            namespace = "forgejo";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "forgejo-db";
            ingress = [
              {
                from = [
                  {
                    podSelector.matchLabels."app.kubernetes.io/name" = "forgejo";
                  }
                ];
                ports = [
                  {
                    port = 5432;
                  }
                ];
              }
            ];
          };
        }

        {
          apiVersion = "networking.k8s.io/v1";
          kind = "NetworkPolicy";
          metadata = {
            name = "forgejo-db-allow-operator";
            namespace = "forgejo";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "forgejo-db";
            ingress = [
              {
                from = [
                  {
                    namespaceSelector.matchLabels."kubernetes.io/metadata.name" = "system";
                    podSelector.matchLabels."app.kubernetes.io/name" = "cloudnative-pg";
                  }
                ];
                ports = [
                  { port = 8000; }
                  { port = 5432; }
                ];
              }
            ];
          };
        }

        {
          apiVersion = "networking.k8s.io/v1";
          kind = "NetworkPolicy";
          metadata = {
            name = "forgejo-db-allow-monitoring";
            namespace = "forgejo";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "forgejo-db";
            ingress = [
              {
                from = [
                  {
                    namespaceSelector.matchLabels."kubernetes.io/metadata.name" = "monitoring";
                    podSelector.matchLabels."app.kubernetes.io/name" = "prometheus";
                  }
                ];
                ports = [
                  {
                    port = 9187;
                  }
                ];
              }
            ];
          };
        }

        {
          apiVersion = "networking.k8s.io/v1";
          kind = "NetworkPolicy";
          metadata = {
            name = "forgejo-db-allow-inter-node";
            namespace = "forgejo";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "forgejo-db";
            ingress = [
              {
                from = [
                  {
                    podSelector.matchLabels."cnpg.io/cluster" = "forgejo-db";
                  }
                ];
                ports = [
                  {
                    port = 5432;
                  }
                ];
              }
            ];
          };
        }

        {
          apiVersion = "postgresql.cnpg.io/v1";
          kind = "Cluster";
          metadata = {
            name = "forgejo-db";
            namespace = "forgejo";
            #annotations."cnpg.io/fencesInstances" = [ "*" ];
          };
          spec = {
            inherit (cfg) instances;
            minSyncReplicas = 0;
            maxSyncReplicas = 0;
            imageCatalogRef = {
              apiGroup = "postgresql.cnpg.io";
              kind = "ClusterImageCatalog";
              name = "postgresql";
              major = 15;
            };

            postgresql.parameters = {
              max_connections = "50";

              shared_buffers = "64MB";
              effective_cache_size = "400MB";
              maintenance_work_mem = "32MB";
              work_mem = "4MB";

              wal_buffers = "2MB";
              min_wal_size = "256MB";
              max_wal_size = "1GB";
              checkpoint_completion_target = "0.9";

              default_statistics_target = "100";
              random_page_cost = "1.1";
              effective_io_concurrency = "200";

              huge_pages = "off";

              log_statement = "none";
              log_min_duration_statement = "1000";
              autovacuum = "on";
              autovacuum_max_workers = "2";
            };

            monitoring = {
              enablePodMonitor = true;
            };

            storage = {
              storageClass = "local-path";
              resizeInUseVolumes = false;
              size = cfg.storageSize;
            };

            walStorage = {
              storageClass = "local-path";
              resizeInUseVolumes = false;
              size = cfg.walStorageSize;
            };

            inherit (cfg) resources;
          }
          // lib.optionalAttrs cfg.backup.enable {
            backup = {
              barmanObjectStore = {
                destinationPath = "s3://forgejo-backup";
                endpointURL = "https://s3.${config.homelab.garage.ingressHost}";
                s3Credentials = {
                  accessKeyId = {
                    name = "forgejo-db-backup-s3-credentials";
                    key = "access-key-id";
                  };
                  secretAccessKey = {
                    name = "forgejo-db-backup-s3-credentials";
                    key = "secret-access-key";
                  };
                };
                data.compression = "snappy";
                wal.compression = "snappy";
              };

              retentionPolicy = "30d";
            };
          };
        }
      ]
      ++ lib.optionals cfg.backup.enable [
        {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "Role";
          metadata = {
            name = "forgejo-db";
            namespace = "forgejo";
          };
          rules = [
            {
              apiGroups = [ "" ];
              resources = [ "secrets" ];
              resourceNames = [ "forgejo-db-backup-s3-credentials" ];
              verbs = [ "get" ];
            }
            {
              apiGroups = [ "postgresql.cnpg.io" ];
              resources = [ "backups" ];
              verbs = [ "get" "list" "watch" "patch" "update" ];
            }
            {
              apiGroups = [ "postgresql.cnpg.io" ];
              resources = [ "backups/status" ];
              verbs = [ "get" "patch" "update" ];
            }
          ];
        }

        {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "RoleBinding";
          metadata = {
            name = "forgejo-db";
            namespace = "forgejo";
          };
          roleRef = {
            apiGroup = "rbac.authorization.k8s.io";
            kind = "Role";
            name = "forgejo-db";
          };
          subjects = [
            {
              kind = "ServiceAccount";
              name = "forgejo-db";
              namespace = "forgejo";
            }
          ];
        }

        {
          apiVersion = "postgresql.cnpg.io/v1";
          kind = "ScheduledBackup";
          metadata = {
            name = "forgejo-db";
            namespace = "forgejo";
          };
          spec = {
            schedule = "0 0 1 * * 0";
            immediate = true;
            backupOwnerReference = "self";
            cluster.name = "forgejo-db";
          };
        }
      ];
    };
  };
}
