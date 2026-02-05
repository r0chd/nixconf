{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.homelab.hytale;
in
{
  imports = [
    ./namespace.nix
    ./statefulset.nix
    ./service.nix
    ./backup.nix
  ];

  options.homelab.hytale = {
    enable = lib.mkEnableOption "hytale";

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Kubernetes resource requests/limits for hytale container.";
    };

    storageSize = lib.mkOption {
      type = types.str;
      default = "10Gi";
      description = "Storage size for hytale world data volume";
    };

    rconPassword = lib.mkOption {
      type = types.str;
    };

    backup = {
      enable = lib.mkEnableOption "hytale backups";

      schedule = lib.mkOption {
        type = types.str;
        default = "15 */6 * * *";
      };

      s3 = {
        region = lib.mkOption {
          default = config.homelab.garage.s3Region;
          type = types.str;
        };

        endpoint = lib.mkOption {
          type = types.str;
          default = "https://s3.${config.homelab.garage.ingressHost}";
        };
      };
    };
  };
}
