{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./deployment.nix
    ./rbac.nix
    ./service.nix
    ./ingress.nix
  ];

  options.homelab.monitoring.kube-ops = {
    enable = lib.mkEnableOption "kube-ops k3s service";

    image = lib.mkOption {
      type = types.str;
      default = "hjacobs/kube-ops-view:23.2.0";
      description = "Docker image for kube-ops";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of kube-ops replicas";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "kube-ops.${config.homelab.domain}" else null;
      description = "Hostname for kube-ops ingress (defaults to kube-ops.<domain> if domain is set)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
