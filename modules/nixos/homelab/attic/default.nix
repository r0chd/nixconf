{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.homelab.attic;
in
{
  imports = [
    ./configmap.nix
    ./deployment.nix
    ./ingress.nix
    ./namespace.nix
    ./service.nix
  ];

  options.homelab.attic = {
    enable = lib.mkEnableOption "attic";

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          "attic.${config.homelab.domain}"
        else
          null;
      description = "Hostname for attic ingress (defaults to attic.<domain>)";
    };

    tokenSecret = lib.mkOption {
      type = types.str;
      description = "Base64-encoded HS256 secret for JWT token signing (ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Resource requests/limits for attic container.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s.secrets = [
      {
        metadata = {
          name = "attic-server-env";
          namespace = "attic";
        };
        stringData = {
          ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64 = cfg.tokenSecret;
        };
      }
    ];
  };
}
