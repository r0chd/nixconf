{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab;
  inherit (lib) types;
in
{
  imports = [
    ./flux
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
    ./auth
    ./portfolio
    ./nextcloud
    ./kyverno
    ./media
    ./attic
    ./hytale
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
        "longhorn"
      ];
      default = "local-path";
    };

    storageClass = lib.mkOption {
      type = lib.types.str;
      internal = true;
    };

    flux = {
      access_key_id = lib.mkOption {
        type = types.str;
      };
      secret_access_key = lib.mkOption {
        type = types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      inherit (cfg) enable;
      manifestDir = "/var/lib/manifests";
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

      secrets = [
        {
          metadata = {
            name = "flux-s3-credentials";
            namespace = "flux-system";
          };
          stringData = {
            accesskey = cfg.flux.access_key_id;
            secretkey = cfg.flux.secret_access_key;
          };
        }
      ];
    };

    environment = {
      systemPackages = [ pkgs.fluxcd ];
      variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };

    sops.templates.rclone = {
      content = ''
        [Garage]
        type = s3
        provider = Cloudflare
        access_key_id = ${cfg.flux.access_key_id}
        secret_access_key = ${cfg.flux.secret_access_key}
        region = auto
        endpoint = https://${cfg.flux.endpoint}
      '';
      path = "/etc/rclone.conf";
    };

    networking.firewall.allowedTCPPorts = [
      2379
      2380
      6443
    ];

    networking.firewall.allowedUDPPorts = [
      5520
      30698
    ];

    users.groups.homelab = { };

    homelab.storageClass = cfg.storageClassName;

    systemd.services.flux-s3-sync = {
      description = "Sync Nix-generated manifests to S3 for Flux";

      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };

      script = ''
        ${pkgs.rclone}/bin/rclone sync ${config.services.k3s.manifestDir} Garage:flux \
          --config /etc/rclone.conf \
          --checksum \
          --verbose \
          --copy-links \
          --s3-no-check-bucket
      '';
    };
  };
}
