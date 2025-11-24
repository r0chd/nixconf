_:
{
  services.k3s.manifests.pvreleased-alert.content = {
    apiVersion = "monitoring.coreos.com/v1";
    kind = "PrometheusRule";
    metadata = {
      name = "prometheus-persitent-volume-released";
      namespace = "monitoring";
      labels = {
        prometheus = "k8s";
        role = "alert-rules";
      };
    };
    spec = {
      groups = [
        {
          name = "persistent-volume-released";
          rules = [
            {
              alert = "PersistentVolumeReleased";
              expr = "kube_persistentvolume_status_phase{phase=\"Released\"} > 0";
              for = "2h";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "Persistent Volume \"{{ $labels.persistentvolume }}\" released";
                description = "PersistentVolume \"{{ $labels.persistentvolume }}\" has been released.";
              };
            }
          ];
        }
      ];
    };
  };
}
