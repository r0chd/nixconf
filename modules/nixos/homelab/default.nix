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
    ./vault
    ./cert-manager
    ./moxwiki
    # ./vaultwarden
    # ./nextcloud
    # ./immich
  ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";

    domain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Global domain for homelab services. Services will default to <service>.<domain> if not explicitly configured.";
      example = "r0chd.pl";
    };
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
# [x] add thanos for longer term metrics storage
# [ ] add quickwit for centralized logging
# [x] add config reloader
# [x] add kube web
# [x] add kube ops
# [x] add alertmanager
# [x] add grafana
# [ ] add vector
# [x] add garage
# [x] finish cert-manager
# [x] add flux
# [ ] ass hashi vault
