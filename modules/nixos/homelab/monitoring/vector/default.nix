{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./service-headless.nix
    ./daemonset.nix
    ./serviceaccount.nix
    ./rbac.nix
    ./configmap.nix
  ];

  options.homelab.monitoring.vector = {
    enable = lib.mkEnableOption "vector";
    sinkUri = lib.mkOption {
      type = types.str;
      default = "http://quickwit-indexer.monitoring.svc.cluster.local:7280/api/v1/logs/ingest";
    };
  };
}
