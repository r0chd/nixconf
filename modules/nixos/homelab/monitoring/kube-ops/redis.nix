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
        args = [
          "--proactor_threads=1"
        ];
        resources = {
          requests = {
            cpu = "500m";
            memory = "256Mi";
          };
          limits = {
            memory = "384Mi";
          };
        };
      };
    };
  };
}
