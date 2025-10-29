{ config, lib, ... }:
let
  cfg = config.homelab;
in
{
  imports = [
    ./atuin
    ./ingress-nginx
    ./garage
    ./system
    ./monitoring
    ./metallb
    # ./cert-manager
    # ./vaultwarden
    # ./nextcloud
    # ./immich
  ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";
  };

  config = lib.mkIf cfg.enable {
    services.k3s = lib.mkDefault {
      inherit (cfg) enable;
      extraFlags = [
        "--disable traefik"
        "--write-kubeconfig-group ${config.users.groups.homelab.name}"
        "--write-kubeconfig-mode 0660"
        "--cluster-cidr 10.244.0.0/16"
      ];
    };

    users.groups.homelab = { };
  };
}

# TODO:
# [x] add cloudnative-pg
# [ ] add thanos for longer term metrics storage
# [ ] add quickwit for centralized logging
# [x] add config reloader
# [x] add kube web
# [ ] add kube ops
# [x] add alertmanager
# [x] add grafana
# [ ] add vector
# [x] add garage
# [ ] finish cert-manager
# [x] add flux
