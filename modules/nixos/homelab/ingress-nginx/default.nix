{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./rbac.nix
    ./configmap.nix
    ./deployment.nix
    ./service.nix
    ./job.nix
    ./namespace.nix
    ./validating-webhook.nix
    ./ingressclass.nix
  ];

  options.homelab.ingress = {
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
