{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.garage;
  inherit (lib) types;
in
{
  imports = [
    ./namespace.nix
    ./configmap.nix
    ./statefulset.nix
    ./service-s3.nix
    ./service-admin.nix
    ./service-rpc.nix
  ];

  options.homelab.garage = {
    enable = lib.mkEnableOption "garage";

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of Garage replicas";
    };

    image = lib.mkOption {
      type = types.str;
      default = "dxflrs/garage:v1.0.1";
      description = "Garage container image";
    };

    replicationMode = lib.mkOption {
      type = types.enum [
        "none"
        "1"
        "2"
        "3"
      ];
      default = "none";
      description = "Replication mode for Garage (none for single node, 1/2/3 for multi-node)";
    };

    s3Region = lib.mkOption {
      type = types.str;
      default = "garage";
      description = "S3 region name";
    };

    rpcSecretFile = lib.mkOption {
      type = types.path;
      description = "Path to file containing the RPC secret (must be 64 hex characters)";
    };

    adminTokenFile = lib.mkOption {
      type = types.path;
      description = "Path to file containing the admin API token";
    };

    metricsTokenFile = lib.mkOption {
      type = types.path;
      description = "Path to file containing the metrics API token";
    };

    storage = {
      dataSize = lib.mkOption {
        type = types.str;
        default = "100Gi";
        description = "Size of data volume";
      };

      metaSize = lib.mkOption {
        type = types.str;
        default = "1Gi";
        description = "Size of metadata volume";
      };

      storageClass = lib.mkOption {
        type = types.str;
        default = "local-path";
        description = "Storage class for persistent volumes";
      };
    };
  };

  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.secrets = [
      {
        name = "garage-secrets";
        namespace = "garage";
        data = {
          rpc-secret = cfg.rpcSecretFile;
          admin-token = cfg.adminTokenFile;
          metrics-token = cfg.metricsTokenFile;
        };
      }
    ];
  };
}
