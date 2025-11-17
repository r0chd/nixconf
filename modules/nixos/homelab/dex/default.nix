{ lib, config, ... }:
let
  cfg = config.homelab.dex;
  inherit (lib) types;
in
{
  imports = [
    ./ingress.nix
    ./rbac.nix
    ./namespace.nix
    ./service.nix
    ./configmap.nix
    ./deployment.nix
  ];

  options.homelab.dex = {
    enable = lib.mkEnableOption "dex";

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "dex.${config.homelab.domain}" else null;
      description = "Hostname for dex ingress (defaults to dex.<domain> if domain is set)";
    };

    clientId = lib.mkOption {
      type = types.str;
    };

    clientSecret = lib.mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.secrets = [
      {
        metadata = {
          name = "github-client";
          namespace = "dex";
        };
        stringData = {
          client-id = cfg.clientId;
          client-secret = cfg.clientSecret;
        };
      }
    ];
  };
}
