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

      accessKeyIdFile = lib.mkOption {
        type = types.str;
        description = "Path to file containing S3 access key";
      };

      secretAccessKeyFile = lib.mkOption {
        type = types.str;
        description = "Path to file containing S3 secret key";
      };
    };

    username = lib.mkOption {
      type = types.str;
      description = "Database username";
    };

    passwordFile = lib.mkOption {
      type = types.str;
      description = "Path to file containing database password";
    };

    uriFile = lib.mkOption {
      type = types.str;
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
              };
            };
          };

          managed.roles = [
            {
              name = cfg.username;
              login = true;
            }
          ];

          monitoring = {
            enablePodMonitor = false;
          };

          inherit (cfg) resources;

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
            inherit (cfg.backup) enable;
            immediate = true;
            retentionPolicy = "30d";

            barmanObjectStore = {
              destinationPath = "s3://atuin-backup";
              endpointURL = "http://s3.${config.homelab.garage.ingressHost}";
              accessKeyId = {
                name = "atuin-backup-credentials";
                key = "access-key-id";
              };
              secretAccessKey = {
                name = "atuin-backup-credentials";
                key = "secret-access-key";
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

    services.k3s.secrets = [
      {
        name = "atuin-db-credentials";
        namespace = "atuin";
        data = {
          password = cfg.passwordFile;
        };
      }
      {
        name = "atuin-secrets";
        namespace = "atuin";
        data = {
          ATUIN_DB_URI = cfg.uriFile;
        };
      }
    ]
    ++ lib.optionals cfg.backup.enable [
      {
        name = "atuin-backup-credentials";
        namespace = "atuin";
        data = {
          "access-key-id" = cfg.backup.accessKeyIdFile;
          "secret-access-key" = cfg.backup.secretAccessKeyFile;
        };
      }
    ];
  };
}
