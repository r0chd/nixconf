{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
in
{
  imports = [
    ./priorityclass.nix
    ./serviceaccount.nix
    ./configmap.nix
    ./crds.nix
    ./clusterrole.nix
    ./clusterrolebinding.nix
    ./daemonset.nix
    ./deployment.nix
    ./csidriver.nix
    ./storageclass.nix
  ];

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
}
