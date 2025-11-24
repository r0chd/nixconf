{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./ingress.nix
    ./configmap.nix
    ./service.nix
    ./deployment.nix
    ./db.nix
  ];

  options.homelab.monitoring.kuvasz = {
    enable = lib.mkEnableOption "kuvasz";

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.monitoring.kuvasz.gated then
            "kuvasz.i.${config.homelab.domain}"
          else
            "kuvasz.${config.homelab.domain}"
        else
          null;
      description = "Hostname for kuvasz ingress (defaults to kuvasz.i.<domain> if gated, kuvasz.<domain> otherwise)";
    };

    retentionDays = lib.mkOption {
      type = types.str;
      default = "30";
    };
  };
}
