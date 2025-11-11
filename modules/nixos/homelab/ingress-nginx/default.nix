{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./ingressclass.nix
    ./configmap.nix
    ./rbac.nix
    ./deployment.nix
    ./service.nix
    ./admission-webhooks
  ];

  options.homelab.ingress = {
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
