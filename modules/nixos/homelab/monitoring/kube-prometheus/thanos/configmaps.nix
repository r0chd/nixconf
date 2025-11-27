{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf cfg.enable {
    # ConfigMap for Thanos object storage configuration (used by compact and rule)
    services.k3s.manifests."thanos-storage-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "thanos-storage";
          namespace = "monitoring";
        };
        data = {
          "config.yaml" = ''
            type: s3
            config:
              bucket: ${cfg.bucket}
              endpoint: "s3.${config.homelab.garage.ingressHost}"
              access_key: ${cfg.access_key}
              secret_key: ${cfg.secret_key}
          '';
        };
      }
    ];

    # ConfigMap for Thanos tracing configuration
    services.k3s.manifests."thanos-tracing-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "thanos-tracing";
          namespace = "monitoring";
        };
        data = {
          "config.yaml" = ''
            type: jaeger
            config:
              service_name: thanos-rule
              sampler_type: const
              sampler_param: 0
          '';
        };
      }
    ];

    # ConfigMap for Thanos rule query configuration
    services.k3s.manifests."thanos-rule-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "thanos-rule";
          namespace = "monitoring";
        };
        data = {
          "query-config.yaml" = ''
            http_config:
              tls_config:
                insecure_skip_verify: false
            static_configs: []
          '';
        };
      }
    ];

    # ConfigMap for alert rules (used by thanos-rule)
    services.k3s.manifests."thanos-alerts-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "alerts";
          namespace = "monitoring";
        };
        data = {
          # Empty rules file - can be populated with actual alert rules later
          "rules.yaml" = ''
            groups: []
          '';
        };
      }
    ];

  };
}

