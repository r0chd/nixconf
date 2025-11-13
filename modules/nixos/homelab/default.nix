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
    ./glance
    ./vaultwarden
    # ./immich
    # ./nextcloud
  ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";

    domain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Global domain for homelab services. Services will default to <service>.<domain> if not explicitly configured.";
    };

    storageClassName = lib.mkOption {
      type = lib.types.enum [
        "local-path"
        "openebs-zfs-localpv"
      ];
      default = "local-path";
    };

    storageClass = lib.mkOption {
      type = lib.types.str;
      internal = true;
      description = "Actual Kubernetes storage class name (derived from storageClassName enum)";
    };

    primaryNode = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "IP or hostname of the primary k3s server to join";
    };

    tokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the token file to use when joining the cluster";
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = lib.mkDefault {
      inherit (cfg) enable;
      extraFlags = [
        "--disable traefik"
        "--disable servicelb"
        "--write-kubeconfig-group ${config.users.groups.homelab.name}"
        "--write-kubeconfig-mode 0660"
        "--cluster-cidr 10.244.0.0/16"
      ]
      ++ lib.optionals (cfg.primaryNode != null) [
        "--server ${cfg.primaryNode}"
      ]
      ++ lib.optionals (cfg.tokenFile != null) [
        "--token-file ${cfg.tokenFile}"
      ];
    };

    users.groups.homelab = { };

    homelab.storageClass = cfg.storageClassName;
  };
}

# TODO:
# [x] add cloudnative-pg
# [x] add thanos for longer term metrics storage
# [ ] add quickwit for centralized logging
# [ ] add vector
# [x] add config reloader
# [x] add kube web
# [x] add kube ops
# [x] add alertmanager
# [x] add grafana
# [x] add garage
# [x] finish cert-manager
# [x] add flux
# [x] add hashi vault
# [ ] configure auth-proxy
