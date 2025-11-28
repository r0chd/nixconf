{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.kube-ops;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.kube-ops-dragonfly.content = {
      apiVersion = "dragonflydb.io/v1alpha1";
      kind = "Dragonfly";
      metadata = {
        name = "kube-ops-dragonfly";
        namespace = "monitoring";
        labels = {
          "app.kubernetes.io/name" = "kube-ops-dragonfly";
          "app.kubernetes.io/component" = "redis";
        };
      };
      spec = {
        replicas = 1;
        resources = {
          requests = {
            cpu = "500m";
            memory = "500Mi";
          };
          limits = {
            cpu = "600m";
            memory = "750Mi";
          };
        };
      };
    };
  };
}
