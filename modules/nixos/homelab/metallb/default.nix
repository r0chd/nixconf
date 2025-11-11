{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./IPAddressPool.nix
    ./L2Advertisement.nix
    ./service.nix
    ./daemonset.nix
    ./rbac.nix
    ./secret.nix
    ./validating-webhook.nix
    ./crd.nix
    ./deployment.nix
    ./configmap.nix
  ];

  options.homelab.metallb.addresses = lib.mkOption {
    type = types.listOf types.str;
    default = [ ];
  };
}
