{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./namespace.nix
    ./deployment.nix
    ./ingress.nix
    ./service.nix
  ];

  options.homelab.portfolio = {
    enable = lib.mkEnableOption "portfolio";

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.portfolio.gated then
            "portfolio.i.${config.homelab.domain}"
          else
            "portfolio.${config.homelab.domain}"
        else
          null;
      description = "Hostname for portfolio ingress (defaults to portfolio.i.<domain> if gated, portfolio.<domain> otherwise)";
    };
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
