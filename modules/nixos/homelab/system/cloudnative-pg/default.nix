{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.system.cloudnative-pg;
  inherit (lib) types;
in
{
  imports = [
    ./crds.nix
    ./namespace.nix
    ./serviceaccount.nix
    ./rbac.nix
    ./configmap.nix
    ./service.nix
    ./deployment.nix
    ./webhooks.nix
    ./cluster-image-catalog.nix
  ];

  options.homelab.system.cloudnative-pg = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    fence = lib.mkEnableOption "fence database";

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };

    databases = lib.mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            enable = lib.mkOption {
              type = types.bool;
              default = true;
            };
            metadata = {
              name = lib.mkOption {
                type = types.str;
              };
              namespace = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
            };

            instances = lib.mkOption {
              type = types.int;
              default = 1;
              description = "Number of PostgreSQL instances";
            };

            storageSize = lib.mkOption {
              type = types.str;
              description = "Storage size for the database";
            };

            walStorageSize = lib.mkOption {
              type = types.str;
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

              bucket = lib.mkOption {
                type = types.str;
                description = "Path to file containing S3 access key";
              };

              s3url = lib.mkOption {
                type = types.str;
                description = "Path to file containing S3 access key";
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
        }
      );
    };
  };
}
