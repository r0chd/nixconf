{ config, lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./namespace.nix
    ./deployment.nix
    ./service.nix
    ./ingress.nix
    ./pvc.nix
    ./db
  ];

  options.homelab.atuin = {
    enable = lib.mkEnableOption "atuin k3s service";

    image = lib.mkOption {
      type = types.str;
      default = "ghcr.io/atuinsh/atuin:latest";
      description = "Docker image for atuin";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of atuin replicas";
    };

    storageSize = lib.mkOption {
      type = types.str;
      default = "1Gi";
      description = "Storage size for atuin configuration volume";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "atuin.${config.homelab.domain}" else null;
      description = "Hostname for atuin ingress (defaults to atuin.<domain> if domain is set)";
    };
  };
}
