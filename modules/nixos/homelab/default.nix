{ config, lib, ... }:
let
  cfg = config.homelab;
in
{
  imports = [
    ./atuin
    ./ingress-nginx
    ./metallb
    ./openebs
    ./pihole
    ./prometheus
    ./reloader
    ./grafana
    #./flannel
    #./cert-manager
    #./vaultwarden
    # ./nextcloud
    # ./immich
  ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";
  };

  config.services.k3s = lib.mkDefault {
    inherit (cfg) enable;
    extraFlags = [
      "--disable traefik"
      "--write-kubeconfig-group wheel"
      "--write-kubeconfig-mode 0660"
    ];
  };
}

# TODO:
# [ ] add thanos for longer term metrics storage
# [ ] add quickwit for centralized logging
# [x] add config reloader
# [ ] add kube web
# [ ] add kube ops
# [x] add alertmanager
# [x] add grafana
# [ ] add vector
# [ ] add minio
# [ ] finish cert-manager
