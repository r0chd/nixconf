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
          http_communication_log_enabled = "true";
          log_handler_enabled = "true";
          data_retention_days = toString cfg.retentionDays;
          http-monitors-external-modifications-enabled = "false";
          http-monitors = builtins.toJSON [
            {
              enabled = true;
              expected-status-codes = [
                200
                201
                303
              ];
              follow-redirects = true;
              force-no-cache = true;
              latency-history-enabled = true;
              name = "Portfolio";
              request-method = "GET";
              ssl-check-enabled = false;
              uptime-check-interval = 60;
              url = "http://portfolio.portfolio.svc.cluster.local:80";
            }
          ];
        };
      }
    ];
  };
}
