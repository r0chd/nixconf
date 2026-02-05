{ config, ... }:
let
  cfg = config.homelab.hytale;
in
{
  services.k3s.manifests.hytale-backup-cronjob = {
    enable = cfg.enable && cfg.backup.enable;
    content = [
      {
        apiVersion = "batch/v1";
        kind = "CronJob";
        metadata = {
          name = "hytale-world-backup";
          namespace = "hytale";
          labels = {
            "app.kubernetes.io/name" = "hytale";
          };
        };
        spec = {
          schedule = cfg.backup.schedule;
          concurrencyPolicy = "Forbid";
          successfulJobsHistoryLimit = 2;
          failedJobsHistoryLimit = 5;
          jobTemplate.spec = {
            backoffLimit = 1;
            template = {
              metadata.labels = {
                "app.kubernetes.io/name" = "hytale";
              };
              spec = {
                restartPolicy = "Never";
                containers = [
                  {
                    name = "backup";
                    image = "rclone/rclone:1.66";
                    envFrom = [
                      {
                        secretRef.name = "hytale-backup-s3-credentials";
                      }
                    ];
                    command = [
                      "/bin/sh"
                      "-lc"
                      ''
                        set -euo pipefail

                        TS="$(date -u +%Y-%m-%dT%H%M%SZ)"
                        ARCHIVE="/tmp/hytale-data-''${TS}.tar.gz"

                        tar -C /data -czf "''${ARCHIVE}" .

                        mkdir -p /root/.config/rclone
                        cat > /root/.config/rclone/rclone.conf <<EOF
                        [s3]
                        type = s3
                        provider = Other
                        env_auth = true
                        region = ${cfg.backup.s3.region}
                        endpoint = ${cfg.backup.s3.endpoint}
                        EOF

                        rclone copyto "''${ARCHIVE}" "s3:hytale-backup/hytale-data-''${TS}.tar.gz"
                      ''
                    ];
                    volumeMounts = [
                      {
                        name = "hytale-data";
                        mountPath = "/data";
                        readOnly = true;
                      }
                    ];
                  }
                ];
                volumes = [
                  {
                    name = "hytale-data";
                    persistentVolumeClaim.claimName = "hytale-data-hytale-0";
                  }
                ];
              };
            };
          };
        };
      }
    ];
  };
}
