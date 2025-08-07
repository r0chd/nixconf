{ config, lib, ... }:
let
  cfg = config.homelab.atuin.db;
  inherit (lib) types;
in
{
  imports = [
    ./deployment.nix
    ./pvc.nix
    ./service.nix
  ];

  options.homelab.atuin.db = {
    replicas = lib.mkOption {
      type = types.int;
      default = 1;
    };
    resources = {
      requests = {
        cpu = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        memory = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      };
      limits = {
        cpu = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        memory = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      };
      storage = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
    username = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    passwordFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    uriFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config.services.k3s.secrets = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) [
    {
      name = "atuin-secrets";
      namespace = "atuin";
      data = {
        ATUIN_DB_PASSWORD = cfg.passwordFile;
        ATUIN_DB_URI = cfg.uriFile;
      };
    }
  ];
}
