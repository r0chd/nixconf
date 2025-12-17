{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./IPAddressPool.nix
    ./L2Advertisement.nix
    ./service.nix
    ./daemonset.nix
    ./rbac.nix
    ./secret.nix
    ./validating-webhook.nix
    ./crd.nix
    ./deployment.nix
    ./configmap.nix
    ./namespace.nix
  ];

  options.homelab.metallb = {
    addresses = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    controller.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits for the MetalLB controller.";
    };

    speaker.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits for the MetalLB speaker.";
    };
  };
}
