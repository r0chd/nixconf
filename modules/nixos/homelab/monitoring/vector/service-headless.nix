{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.vector.enable) {
    services.k3s.manifests."vector-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "vector-headless";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
            "app.kubernetes.io/version" = "0.51.0-distroless-libc";
          };
          annotations = null;
        };
        spec = {
          clusterIP = "None";
          ports = [
            {
              name = "datadog-agent";
              port = 8282;
              protocol = "TCP";
            }
            {
              name = "fluent";
              port = 24224;
              protocol = "TCP";
            }
            {
              name = "logstash";
              port = 5044;
              protocol = "TCP";
            }
            {
              name = "splunk-hec";
              port = 8080;
              protocol = "TCP";
            }
            {
              name = "statsd";
              port = 8125;
              protocol = "TCP";
            }
            {
              name = "syslog";
              port = 9000;
              protocol = "TCP";
            }
            {
              name = "vector";
              port = 6000;
              protocol = "TCP";
            }
            {
              name = "prom-exporter";
              port = 9090;
              protocol = "TCP";
            }
          ];
          selector = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
          };
          type = "ClusterIP";
        };
      }
    ];
  };
}
