{ config, lib, ... }:
let
  cfg = config.homelab.atuin.db;
in
{
  services.k3s.manifests.atuin.content = [
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "postgres";
        namespace = "atuin";
      };
      spec = {
        inherit (cfg) replicas;
        strategy.type = "Recreate";
        selector.matchLabels."io.kompose.service" = "postgres";
        template = {
          metadata.labels."io.kompose.service" = "postgres";
          spec = {
            containers = [
              {
                name = "postgresql";
                image = "postgres:14";
                ports = [ { containerPort = 5432; } ];
                env = [
                  {
                    name = "POSTGRES_DB";
                    value = "atuin";
                  }
                  {
                    name = "POSTGRES_PASSWORD";
                    valueFrom.secretKeyRef = {
                      name = "atuin-secrets";
                      key = "ATUIN_DB_PASSWORD";
                      optional = false;
                    };
                  }
                  {
                    name = "POSTGRES_USER";
                    value = cfg.username;
                  }
                ];
                lifecycle.preStop.exec.command = [
                  "/usr/local/bin/pg_ctl stop -D /var/lib/postgresql/data -w -t 60 -m fast"
                ];

                resources =
                  lib.optionalAttrs (cfg.resources.requests != null) { inherit (cfg.resources) requests; }
                  // lib.optionalAttrs (cfg.resources.limits != null) { inherit (cfg.resources) limits; };

                volumeMounts = [
                  {
                    mountPath = "/var/lib/postgresql/data/";
                    name = "database";
                  }
                ];
              }
            ];
            volumes = [
              {
                name = "database";
                persistentVolumeClaim.claimName = "database";
              }
            ];
          };
        };
      };
    }
  ];
}
