{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.homelab.monitoring.thanos;
in
{
  imports = [
    ./query
    ./query-frontend
    ./store
    ./receive
    ./compact
    ./rule
    ./bucket
    ./sidecar
  ];

  options.homelab.monitoring.thanos = {
    enable = lib.mkEnableOption "thanos";

    thanosObjectStorageFile = lib.mkOption {
      type = types.str;
    };

    image = lib.mkOption {
      type = types.str;
      default = "quay.io/thanos/thanos:v0.30.2";
      description = "Docker image for thanos components";
    };

    query = {
      replicas = lib.mkOption {
        type = types.int;
        default = 1;
        description = "Number of thanos-query replicas";
      };
    };

    queryFrontend = {
      replicas = lib.mkOption {
        type = types.int;
        default = 1;
        description = "Number of thanos-query-frontend replicas";
      };
    };

    store = {
      replicas = lib.mkOption {
        type = types.int;
        default = 1;
        description = "Number of thanos-store replicas";
      };
      storageSize = lib.mkOption {
        type = types.str;
        default = "10Gi";
        description = "Storage size for thanos-store data volume";
      };
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "thanos.${config.homelab.domain}" else null;
      description = "Hostname for thanos query-frontend ingress (defaults to thanos.<domain> if domain is set)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s.secrets = [
      {
        name = "thanos-objectstorage";
        namespace = "monitoring";
        data."thanos.yaml" = cfg.thanosObjectStorageFile;
      }
    ];
  };
}
