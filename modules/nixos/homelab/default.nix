{ config, lib, ... }:
let
  cfg = config.homelab;
in
{
  imports = [
    ./atuin
    ./cert-manager
    ./flannel
    ./ingress-nginx
    ./metallb
    ./openebs
    ./pihole
    ./prometheus
    ./vaultwarden
    # ./nextcloud
    # ./immich
  ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";
  };

  config.services.k3s = lib.mkDefault { inherit (cfg) enable; };
}
