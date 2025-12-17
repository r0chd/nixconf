{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./service-account.nix
    ./namespace.nix
    ./cluster-role-binding.nix
    ./validating-webhook-configuration.nix
    ./mutating-webhook-configuration.nix
    ./deployment.nix
    ./role.nix
    ./service.nix
    ./cluster-role.nix
    ./crd.nix
    ./role-binding.nix
    ./self-signed-issuer.nix
    ./cluster-issuer.nix
  ];

  options.homelab.cert-manager = {
    enable = lib.mkEnableOption "cert-manager" // {
      default = true;
      description = "Whether to enable cert-manager for automatic TLS certificate management.";
    };

    injector.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits.";
    };
    controller.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits.";
    };
    webhook.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits.";
    };
  };
}
