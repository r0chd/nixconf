{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./deployment.nix
    ./rbac.nix
    ./service.nix
    ./ingress.nix
  ];

  options.homelab.monitoring.kube-web = {
    enable = lib.mkEnableOption "kube-web k3s service";

    image = lib.mkOption {
      type = types.str;
      default = "hjacobs/kube-web-view:23.2.0";
      description = "Docker image for kube-web";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of kube-web replicas";
    };

    ingressHost = lib.mkOption {
      type = types.str;
      description = "Hostname for kube-web ingress";
    };
  };
}
