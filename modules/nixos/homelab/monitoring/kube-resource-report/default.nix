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
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then "kube-resource-report.${config.homelab.domain}" else null;
      description = "Hostname for kube-resource-report ingress (defaults to kube-resource-report.<domain> if domain is set)";
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
