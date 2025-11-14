{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.system.zfs-localpv;
  inherit (lib) types;
in
{
  options.homelab.system.zfs-localpv = {
    enable = lib.mkOption {
      type = types.bool;
      default = config.homelab.storageClassName == "zfs-localpv";
      description = "Enable zfs-localpv storage class";
    };
    poolname = lib.mkOption {
      type = types.str;
    };
  };

  config.services.k3s.autoDeployCharts.zfs-localpv = lib.mkIf cfg.enable {
    name = "zfs-localpv";
    repo = "https://openebs.github.io/openebs";
    version = "4.2.0";
    hash = "sha256-rUZcfcB+O7hrr2swEARXFujN7VvfC0IkaaAeJTi0mN0=";
    targetNamespace = "system";
    values = {
    };
  };
}
