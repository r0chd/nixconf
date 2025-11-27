{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kuvasz;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."kuvasz-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "kuvasz-config";
          namespace = "monitoring";
        };
        data = {
          "http-monitors.yaml" = ''
            http-monitors-external-modifications-enabled: false
            http-monitors:
              - enabled: true
                expected-status-codes: [200, 201, 303]
                follow-redirects: true
                force-no-cache: true
                latency-history-enabled: true
                name: Portfolio
                request-method: GET
                ssl-check-enabled: false
                uptime-check-interval: 60
                url: http://portfolio.portfolio.svc.cluster.local:80
          '';
          "application.yml" = ''
            kuvasz:
              http-communication-log-enabled: true
              log-handler-enabled: true
              data-retention-days: ${toString cfg.retentionDays}
          '';
        };
      }
    ];
  };
}
