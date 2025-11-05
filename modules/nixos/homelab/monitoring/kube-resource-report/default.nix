{ lib, ... }:
{
  imports = [
    ./configmap.nix
    ./deployment.nix
    ./rbac.nix
    ./service.nix
  ];

  options.homelab.kube-resource-report = {
    enable = lib.mkEnableOption "kube-resource-report";
  };
}
