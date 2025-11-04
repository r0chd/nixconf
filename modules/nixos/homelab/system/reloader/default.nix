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
  ];

  options.homelab.system.reloader = {
    enable = lib.mkEnableOption "reloader";

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
  };
}
