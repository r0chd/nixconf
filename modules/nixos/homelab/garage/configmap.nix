{ config, lib, ... }:
let
  cfg = config.homelab.garage;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.garage-configmap.content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "garage-config";
          namespace = "default";
        };
        data."garage.toml" = ''
          metadata_dir = "/meta"
          data_dir = "/data"

          db_engine = "lmdb"

          replication_factor = ${toString cfg.replicationFactor}
          consistency_mode = "${cfg.consistencyMode}"

          compression_level = 1

          rpc_bind_addr = "[::]:3901"
          rpc_public_addr = "garage-0.garage.default.svc.cluster.local:3901"
          rpc_secret_file = "/secrets/rpc-secret"

          [s3_api]
          s3_region = "${cfg.s3Region}"
          api_bind_addr = "[::]:3900"
          root_domain = ".s3.garage.localhost"

          [s3_web]
          bind_addr = "[::]:3903"
          root_domain = ".web.garage.localhost"
          index = "index.html"

          [admin]
          api_bind_addr = "[::]:3902"
          metrics_token_file = "/secrets/metrics-token"
          admin_token_file = "/secrets/admin-token"
        '';
      }
    ];
  };
}
