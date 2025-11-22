{ config, lib, ... }:
let
  cfg = config.homelab.quickwit.db;
  inherit (lib) types;
in
{
  options.homelab.quickwit.db = {
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
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };

    backup = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Enable database backups";
      };

      accessKeyIdFile = lib.mkOption {
        type = types.str;
        description = "Path to file containing S3 access key";
      };

      secretAccessKeyFile = lib.mkOption {
        type = types.str;
        description = "Path to file containing S3 secret key";
      };
    };
  };

  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.quickwit.enable) {
    services.k3s = {
      manifests.cnpg-databases.content = [
        {
          apiVersion = "networking.k8s.io/v1";
          kind = "NetworkPolicy";
          metadata = {
            name = "quickwit-db-allow-app";
            namespace = "monitoring";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "quickwit-db";
            ingress = [
              {
                from = [
                  {
                    podSelector.matchLabels."app.kubernetes.io/name" = "quickwit";
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
            name = "quickwit-db-allow-operator";
            namespace = "monitoring";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "quickwit-db";
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
            name = "quickwit-db-allow-monitoring";
            namespace = "monitoring";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "quickwit-db";
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
            name = "quickwit-db-allow-inter-node";
            namespace = "monitoring";
          };
          spec = {
            podSelector.matchLabels."cnpg.io/cluster" = "quickwit-db";
            ingress = [
              {
                from = [
                  {
                    podSelector.matchLabels."cnpg.io/cluster" = "quickwit-db";
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
            name = "quickwit-db";
            namespace = "monitoring";
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
              storageClass = config.homelab.storageClass;
              resizeInUseVolumes = false;
              size = cfg.storageSize;
            };

            walStorage = {
              storageClass = config.homelab.storageClass;
              resizeInUseVolumes = false;
              size = cfg.walStorageSize;
            };

            inherit (cfg) resources;
          }
          // lib.optionalAttrs cfg.backup.enable {
            backup = {
              barmanObjectStore = {
                destinationPath = "s3://quickwit-backup";
                endpointURL = "https://s3.${config.homelab.garage.ingressHost}";
                s3Credentials = {
                  accessKeyId = {
                    name = "quickwit-backup-credentials";
                    key = "access-key-id";
                  };
                  secretAccessKey = {
                    name = "quickwit-backup-credentials";
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
          apiVersion = "postgresql.cnpg.io/v1";
          kind = "ScheduledBackup";
          metadata = {
            name = "quickwit-db";
            namespace = "monitoring";
          };
          spec = {
            schedule = "0 0 1 * * 0";
            immediate = true;
            backupOwnerReference = "self";
            cluster.name = "quickwit-db";
          };
        }
      ];

      secrets = lib.mkIf cfg.backup.enable [
        {
          metadata = {
            name = "quickwit-backup-credentials";
            namespace = "monitoring";
          };
          stringData = {
            "access-key-id" = cfg.backup.accessKeyId;
            "secret-access-key" = cfg.backup.secretAccessKey;
          };
        }
      ];
    };
  };
}
