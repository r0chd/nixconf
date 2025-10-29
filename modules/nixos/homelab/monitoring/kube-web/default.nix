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

  options.homelab.kube-web = {
    enable = lib.mkEnableOption "kube-web k3s service";

    ingressHost = lib.mkOption {
      type = types.str;
      description = "Hostname for kube-web ingress";
    };
  };
}
