{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./configmap.nix
    ./deployment.nix
    ./rbac.nix
    ./service.nix
    ./ingress.nix
  ];

  options.homelab.monitoring.kube-resource-report = {
    enable = lib.mkEnableOption "kube-resource-report";
    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.monitoring.kube-resource-report.gated then "kube-resource-report.i.${config.homelab.domain}" else "kube-resource-report.${config.homelab.domain}"
        else null;
      description = "Hostname for kube-resource-report ingress (defaults to kube-resource-report.i.<domain> if gated, kube-resource-report.<domain> otherwise)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };

    nginx.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
