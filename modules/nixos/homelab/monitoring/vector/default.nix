{ lib, ... }:
{
  imports = [
    ./service-headless.nix
    ./daemonset.nix
    ./serviceaccount.nix
    ./rbac.nix
    ./configmap.nix
  ];

  options.homelab.monitoring.vector = {
    enable = lib.mkEnableOption "vector";
  };
}
