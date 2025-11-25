{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.system.longhorn;
  inherit (lib) types;
in
{
  imports = [
    ./job.nix
    ./configmap.nix
    ./service.nix
    ./rbac.nix
    ./crd.nix
    ./daemonset.nix
    ./deployment.nix
    ./ingress.nix
  ];

  options.homelab.system.longhorn = {
    enable = lib.mkOption {
      type = types.bool;
      default = config.homelab.storageClassName == "longhorn";
      description = "Enable zfs-localpv storage class";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 3;
    };

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.monitoring.kube-ops.gated then
            "kube-ops.i.${config.homelab.domain}"
          else
            "kube-ops.${config.homelab.domain}"
        else
          null;
      description = "Hostname for kube-ops ingress (defaults to kube-ops.i.<domain> if gated, kube-ops.<domain> otherwise)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    systemd.services.iscsid.serviceConfig = {
      PrivateMounts = "yes";
      BindPaths = "/run/current-system/sw/bin:/bin";
    };
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin"
    ];
    virtualisation.docker.logDriver = "json-file";
  };
}
