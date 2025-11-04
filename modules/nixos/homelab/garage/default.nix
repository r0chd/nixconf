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
    ./configmap.nix
    ./statefulset.nix
    ./service.nix
    ./service-s3.nix
    ./service-admin.nix
    ./service-rpc.nix
    ./ingress.nix
  ];

  options.homelab.garage = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    image = lib.mkOption {
      type = types.str;
      default = "dxflrs/garage:v1.0.1";
      description = "Docker image for garage";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of garage replicas";
    };

    replicationFactor = lib.mkOption {
      type = types.int;
      default = 1;
    };

    consistencyMode = lib.mkOption {
      type = types.enum [
        "consistent"
        "degraded"
        "dangerous"
      ];
      default = "consistent";
    };

    s3Region = lib.mkOption {
      type = types.str;
      default = "garage";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    rpcSecretFile = lib.mkOption {
      type = types.path;
    };

    adminTokenFile = lib.mkOption {
      type = types.path;
    };

    metricsTokenFile = lib.mkOption {
      type = types.path;
    };

    storage = {
      dataSize = lib.mkOption {
        type = types.str;
        default = "100Gi";
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
        namespace = "default";
        data = {
          rpc-secret = cfg.rpcSecretFile;
          admin-token = cfg.adminTokenFile;
          metrics-token = cfg.metricsTokenFile;
        };
      }
    ];
  };
}
