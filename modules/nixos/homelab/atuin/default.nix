{ config, lib, ... }:
let
  cfg = config.homelab.atuin;
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
  };
}
