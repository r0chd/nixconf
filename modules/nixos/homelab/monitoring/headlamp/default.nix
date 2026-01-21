{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./deployment.nix
    ./service.nix
    ./ingress.nix
  ];

  options.homelab.monitoring.headlamp = {
    enable = lib.mkEnableOption "Headlamp k3s service";

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate Headlamp behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.monitoring.headlamp.gated then
            "headlamp.i.${config.homelab.domain}"
          else
            "headlamp.${config.homelab.domain}"
        else
          null;
      description = "Hostname for the Headlamp ingress";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits for Headlamp";
    };
  };
}
