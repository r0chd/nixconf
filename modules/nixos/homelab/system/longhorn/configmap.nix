{ lib, config, ... }:
let
  cfg = config.homelab.system.longhorn;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.longhorn-configmap.content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "longhorn-default-resource";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        data = {
          "default-resource.yaml" = "";
        };
      }
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "longhorn-default-setting";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        data = {
          "default-setting.yaml" =
            "priority-class: \"longhorn-critical\"\ndisable-revision-counter: \"{\\\"v1\\\":\\\"true\\\"}\"\ndefault-replica-count: ${toString cfg.replicas}\nreplica-soft-anti-affinity: false";
        };
      }
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "longhorn-storageclass";
          namespace = "system";
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
          };
        };
        data = {
          "storageclass.yaml" = ''
            kind: StorageClass
            apiVersion: storage.k8s.io/v1
            metadata:
              name: longhorn
              annotations:
                storageclass.kubernetes.io/is-default-class: "true"
            provisioner: driver.longhorn.io
            allowVolumeExpansion: true
            reclaimPolicy: "Delete"
            volumeBindingMode: Immediate
            parameters:
              numberOfReplicas: "${toString cfg.replicas}"
              staleReplicaTimeout: "30"
              fromBackup: ""
              fsType: "xfs"
              dataLocality: "disabled"
              unmapMarkSnapChainRemoved: "ignored"
              disableRevisionCounter: "true"
              dataEngine: "v1"
              backupTargetName: "default"
          '';
        };
      }
    ];
  };
}
