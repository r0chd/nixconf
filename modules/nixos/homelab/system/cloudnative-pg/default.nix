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

  options.homelab.cloudnative-pg = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    image = lib.mkOption {
      type = types.str;
      default = "ghcr.io/cloudnative-pg/cloudnative-pg:1.24.4";
      description = "CloudNativePG operator container image";
    };
  };
}
