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
      default = "hjacobs/kube-ops-view:23.5.0";
      description = "Docker image for kube-ops";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of kube-ops replicas";
    };

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.monitoring.kube-ops.gated then
            "kube-ops.i.${config.homelab.domain}"
          else
            "kube-ops.${config.homelab.domain}"
        else
          null;
      description = "Hostname for kube-ops ingress (defaults to kube-ops.i.<domain> if gated, kube-ops.<domain> otherwise)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits.";
    };
  };
}
