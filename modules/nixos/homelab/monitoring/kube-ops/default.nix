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

  options.homelab.kube-ops = {
    enable = lib.mkEnableOption "kube-ops k3s service";

    ingressHost = lib.mkOption {
      type = types.str;
      description = "Hostname for kube-ops ingress";
    };
  };
}
