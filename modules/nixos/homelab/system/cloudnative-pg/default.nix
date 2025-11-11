{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  imports = [
    ./crds.nix
    ./namespace.nix
    ./serviceaccount.nix
    ./rbac.nix
    ./configmap.nix
    ./service.nix
    ./deployment.nix
    ./webhooks.nix
    ./cluster-image-catalog.nix
  ];

  options.homelab.system.cloudnative-pg = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
