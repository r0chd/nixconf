{ ... }:
{
  services.k3s.manifests.smart-alert.content = {
    apiVersion = "monitoring.coreos.com/v1";
    kind = "PrometheusRule";
    metadata = {
      name = "smart-alerts";
      namespace = "monitoring";
      labels = {
        prometheus = "k8s";
        role = "alert-rules";
      };
    };
    spec = {
      groups = [
        {
          name = "smart-device-failed";
          rules = [
            {
              alert = "SmartCtlDeviceFailed";
              expr = "smartctl_device_smart_status == 0";
              for = "2m";
              labels = {
                severity = "critical";
              };
              annotations = {
                summary = "SMART health check failed for device {{ $labels.device }}";
                description = "Device {{ $labels.device }} on {{ $labels.instance }} has failed\nits overall SMART health check.";
              };
            }
          ];
        }
      ];
    };
  };
}
