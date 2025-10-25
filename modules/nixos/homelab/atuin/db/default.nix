{ config, lib, ... }:
let
  cfg = config.homelab.atuin.db;
  inherit (lib) types;
in
{
  options.homelab.atuin.db = {
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

    resources = {
      requests = {
        cpu = lib.mkOption {
          type = types.str;
          default = "100m";
        };
        memory = lib.mkOption {
          type = types.str;
          default = "256Mi";
        };
      };
      limits = {
        cpu = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        memory = lib.mkOption {
          type = types.str;
          default = "512Mi";
        };
      };
    };

    backup = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Enable database backups";
      };

      schedule = lib.mkOption {
        type = types.str;
        default = "0 0 1 * * 0";
        description = "Backup schedule (cron format)";
      };

      destinationPath = lib.mkOption {
        type = types.str;
        default = "s3://backups/atuin-db-backup";
        description = "S3 destination path for backups";
      };

      endpointURL = lib.mkOption {
        type = types.str;
        default = "http://minio.default.svc.cluster.local:9000";
        description = "S3 endpoint URL";
      };

      accessKeySecret = lib.mkOption {
        type = types.str;
        default = "atuin-db-backup-creds";
        description = "Secret name containing S3 access key";
      };

      secretKeySecret = lib.mkOption {
        type = types.str;
        default = "atuin-db-backup-creds";
        description = "Secret name containing S3 secret key";
      };
    };

    username = lib.mkOption {
      type = types.str;
      default = "atuin";
      description = "Database username";
    };

    passwordFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to file containing database password";
    };

    uriFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to file containing database URI";
    };
  };

  config = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) {
    homelab.database.cloudnative-pg = {
      clusters = {
        "atuin-db" = {
          namespace = "atuin";
          inherit (cfg) instances;
          minSyncReplicas = 0;
          maxSyncReplicas = 0;
          postgresVersion = "15";

          postgresParameters = {
            max_connections = "100";
            shared_buffers = "128MB";
            effective_cache_size = "384MB";
            maintenance_work_mem = "64MB";
            checkpoint_completion_target = "0.9";
            wal_buffers = "4MB";
            default_statistics_target = "100";
            random_page_cost = "1.1";
            effective_io_concurrency = "200";
            work_mem = "1310kB";
            huge_pages = "off";
            min_wal_size = "256MB";
            max_wal_size = "1GB";
          };

          bootstrap = {
            initdb = {
              database = "atuin";
              owner = cfg.username;
              secret = {
                name = "atuin-db-credentials";
                key = "password";
              };
            };
          };

          monitoring = {
            enablePodMonitor = false;
          };

          resources = {
            requests = {
              cpu = cfg.resources.requests.cpu;
              memory = cfg.resources.requests.memory;
            };
            limits = {
              cpu = cfg.resources.limits.cpu;
              memory = cfg.resources.limits.memory;
            };
          };

          storage = {
            size = cfg.storageSize;
            storageClass = "local-path";
            resizeInUseVolumes = false;
          };

          walStorage = {
            size = cfg.walStorageSize;
            storageClass = "local-path";
            resizeInUseVolumes = false;
          };

          backup = {
            enable = cfg.backup.enable;
            schedule = cfg.backup.schedule;
            immediate = false;
            retentionPolicy = "30d";

            barmanObjectStore = {
              destinationPath = cfg.backup.destinationPath;
              endpointURL = cfg.backup.endpointURL;
              accessKeySecret = {
                name = cfg.backup.accessKeySecret;
                key = "access-key";
              };
              secretKeySecret = {
                name = cfg.backup.secretKeySecret;
                key = "secret-key";
              };
              compression = "snappy";
            };
          };

          networkPolicies = {
            enable = true;
            allowFromApps = [ "atuin" ];
            allowPrometheus = true;
            allowOperator = true;
            allowInterNode = false;
          };
        };
      };
    };

    environment.etc."k3s-secrets/atuin-db-username".text = cfg.username;

    services.k3s.secrets = lib.mkMerge [
      (lib.mkIf (cfg.passwordFile != null) [
        {
          name = "atuin-db-credentials";
          namespace = "atuin";
          data = {
            username = "/etc/k3s-secrets/atuin-db-username";
            password = cfg.passwordFile;
          };
        }
      ])
      (lib.mkIf (cfg.uriFile != null) [
        {
          name = "atuin-secrets";
          namespace = "atuin";
          data = {
            ATUIN_DB_URI = cfg.uriFile;
          };
        }
      ])
    ];
  };
}
