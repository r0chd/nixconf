{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./cloudnative-pg.nix
  ];

  options.homelab.database = {
    cloudnative-pg = {
      clusters = lib.mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              namespace = lib.mkOption {
                type = types.str;
                description = "Namespace for the database cluster";
              };

              instances = lib.mkOption {
                type = types.int;
                default = 3;
                description = "Number of PostgreSQL instances";
              };

              minSyncReplicas = lib.mkOption {
                type = types.int;
                default = 1;
                description = "Minimum synchronous replicas";
              };

              maxSyncReplicas = lib.mkOption {
                type = types.int;
                default = 1;
                description = "Maximum synchronous replicas";
              };

              postgresVersion = lib.mkOption {
                type = types.str;
                default = "15";
                description = "PostgreSQL major version";
              };

              postgresParameters = lib.mkOption {
                type = types.attrsOf types.str;
                default = {
                  max_connections = "100";
                  shared_buffers = "512MB";
                  effective_cache_size = "1536MB";
                  maintenance_work_mem = "128MB";
                  checkpoint_completion_target = "0.9";
                  wal_buffers = "16MB";
                  default_statistics_target = "100";
                  random_page_cost = "1.1";
                  effective_io_concurrency = "200";
                  work_mem = "4854kB";
                  huge_pages = "off";
                  min_wal_size = "1GB";
                  max_wal_size = "4GB";
                };
                description = "PostgreSQL configuration parameters";
              };

              bootstrap = {
                initdb = {
                  database = lib.mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Database name to create";
                  };
                  owner = lib.mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Database owner username";
                  };
                  secret = {
                    name = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Secret name containing database credentials";
                    };
                    key = lib.mkOption {
                      type = types.str;
                      default = "password";
                      description = "Secret key for password";
                    };
                  };
                };
              };

              resources = {
                requests = {
                  cpu = lib.mkOption {
                    type = types.nullOr types.str;
                    default = "200m";
                    description = "CPU request";
                  };
                  memory = lib.mkOption {
                    type = types.nullOr types.str;
                    default = "2Gi";
                    description = "Memory request";
                  };
                };
                limits = {
                  cpu = lib.mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "CPU limit";
                  };
                  memory = lib.mkOption {
                    type = types.nullOr types.str;
                    default = "2Gi";
                    description = "Memory limit";
                  };
                };
              };

              storage = {
                size = lib.mkOption {
                  type = types.str;
                  default = "20Gi";
                  description = "Storage size";
                };
                storageClass = lib.mkOption {
                  type = types.str;
                  default = "local-path";
                  description = "Storage class";
                };
                resizeInUseVolumes = lib.mkOption {
                  type = types.bool;
                  default = false;
                  description = "Allow resizing volumes in use";
                };
              };

              walStorage = {
                size = lib.mkOption {
                  type = types.str;
                  default = "5Gi";
                  description = "WAL storage size";
                };
                storageClass = lib.mkOption {
                  type = types.str;
                  default = "local-path";
                  description = "WAL storage class";
                };
                resizeInUseVolumes = lib.mkOption {
                  type = types.bool;
                  default = false;
                  description = "Allow resizing WAL volumes in use";
                };
              };

              backup = {
                enable = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = "Enable backups";
                };

                schedule = lib.mkOption {
                  type = types.str;
                  default = "0 0 1 * * 0";
                  description = "Backup schedule (cron format: minute hour day month weekday)";
                };

                immediate = lib.mkOption {
                  type = types.bool;
                  default = false;
                  description = "Run backup immediately on creation";
                };

                retentionPolicy = lib.mkOption {
                  type = types.str;
                  default = "90d";
                  description = "Backup retention policy";
                };

                barmanObjectStore = {
                  destinationPath = lib.mkOption {
                    type = types.str;
                    description = "S3 destination path (e.g., s3://bucket-name/cluster-name-backup)";
                  };
                  endpointURL = lib.mkOption {
                    type = types.str;
                    description = "S3 endpoint URL";
                  };
                  accessKeySecret = {
                    name = lib.mkOption {
                      type = types.str;
                      description = "Secret name containing access key";
                    };
                    key = lib.mkOption {
                      type = types.str;
                      default = "access-key";
                      description = "Secret key for access key";
                    };
                  };
                  secretKeySecret = {
                    name = lib.mkOption {
                      type = types.str;
                      description = "Secret name containing secret key";
                    };
                    key = lib.mkOption {
                      type = types.str;
                      default = "secret-key";
                      description = "Secret key for secret key";
                    };
                  };
                  compression = lib.mkOption {
                    type = types.enum [
                      "none"
                      "snappy"
                      "gzip"
                      "bzip2"
                    ];
                    default = "snappy";
                    description = "Compression algorithm";
                  };
                };
              };

              monitoring = {
                enablePodMonitor = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = "Enable PodMonitor for Prometheus";
                };
              };

              networkPolicies = {
                enable = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = "Enable network policies";
                };

                allowFromApps = lib.mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = "List of app names to allow connection from";
                };

                allowFromNamespaces = lib.mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = "List of namespace names to allow connection from";
                };

                allowPrometheus = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = "Allow connection from Prometheus";
                };

                allowOperator = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = "Allow connection from CNPG operator";
                };

                allowInterNode = lib.mkOption {
                  type = types.bool;
                  default = true;
                  description = "Allow inter-node communication";
                };
              };
            };
          }
        );
        default = { };
        description = "CloudNativePG database clusters";
      };
    };
  };
}
