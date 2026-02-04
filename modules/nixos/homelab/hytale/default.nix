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
  };

  config.services.k3s.secrets = [
    {
      metadata = {
        name = "hytale-rcon-password";
        namespace = "hytale";
      };
      stringData = {
        RCON_PASSWORD = cfg.rconPassword;
      };
    }
  ];
}
