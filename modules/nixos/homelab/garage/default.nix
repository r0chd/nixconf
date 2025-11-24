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
    enable = lib.mkEnableOption "garage";

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

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if cfg.gated then "garage.i.${config.homelab.domain}" else "garage.${config.homelab.domain}"
        else
          null;
      description = "Hostname base for garage ingress (defaults to garage.i.<domain> if gated, garage.<domain> otherwise)";
    };

    rpcSecret = lib.mkOption {
      type = types.str;
    };

    adminToken = lib.mkOption {
      type = types.str;
    };

    metricsToken = lib.mkOption {
      type = types.str;
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
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
        default = config.homelab.storageClass;
        description = "Storage class for persistent volumes";
      };
    };
  };

  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.secrets = [
      {
        metadata = {
          name = "garage-secrets";
          namespace = "default";
        };
        stringData = {
          rpc-secret = cfg.rpcSecret;
          admin-token = cfg.adminToken;
          metrics-token = cfg.metricsToken;
        };
      }
    ];
  };
}
