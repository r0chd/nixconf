{ config, lib, ... }:
let
  cfg = config.homelab;
in
{
  imports = [
    ./ingress-nginx
    ./garage
    ./system
    ./monitoring
    ./metallb
    ./cert-manager
    ./moxwiki
    ./glance
    ./vaultwarden
    ./forgejo
    ./flux
    ./auth
    ./immich
    ./portfolio
    # ./nextcloud
  ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";

    nodeType = lib.mkOption {
      type = lib.types.enum [
        "primary"
        "connecting"
        "only"
      ];
      default = "primary";
      description = "Whether this node is the initial node or a node that joins the cluster";
    };

    connecting = {
      primaryNodeIp = lib.mkOption {
        type = lib.types.str;
      };

      tokenFile = lib.mkOption {
        type = lib.types.str;
      };
    };

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
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      inherit (cfg) enable;
      disableAgent = false;
      extraFlags = [
        "--disable traefik"
        "--disable servicelb"
        "--write-kubeconfig-group ${config.users.groups.homelab.name}"
        "--write-kubeconfig-mode 0660"
      ];

      clusterInit = cfg.nodeType == "primary";

      serverAddr = if cfg.nodeType == "connecting" then cfg.connecting.primaryNodeIp else "";
      tokenFile = if cfg.nodeType == "connecting" then cfg.connecting.tokenFile else null;
    };

    networking.firewall.allowedTCPPorts = [
      2379
      2380
      6443
    ];

    users.groups.homelab = { };

    homelab.storageClass = cfg.storageClassName;

    services.gitDaemon = {
      enable = cfg.nodeType == "only" || cfg.nodeType == "primary";
      basePath = "/var/lib";
      exportAll = true;
    };
  };
}

# TODO:
# [x] add cloudnative-pg
# [x] add thanos for longer term metrics storage
# [x] add quickwit for centralized logging
# [x] add vector
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
