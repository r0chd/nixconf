{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./serviceaccount.nix
    ./clusterrole.nix
    ./clusterrolebinding.nix
    ./deployment.nix
    ./role.nix
  ];

  options.homelab.system.reloader = {
    image = lib.mkOption {
      type = types.str;
      default = "ghcr.io/stakater/reloader:v1.0.121";
      description = "Docker image for reloader";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of reloader replicas";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits.";
    };
  };
}
