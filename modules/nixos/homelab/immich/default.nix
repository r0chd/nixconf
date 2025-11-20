{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.immich;
in
{
  imports = [
    ./db.nix
  ];

  options.homelab.immich = {
    enable = lib.mkEnableOption "immich";
  };

  config.services.k3s = lib.mkIf cfg.enable {
    autoDeployCharts.immich = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://immich-app.github.io/immich-charts";
        chart = "immich";
        version = "0.10.3";
        chartHash = "sha256-E9lqIjUe1WVEV8IDrMAbBTJMKj8AzpigJ7fNDCYYo8Y=";
      };
      targetNamespace = "immich";
      createNamespace = true;

      values = {
        env = {
          REDIS_HOSTNAME = "redis://immich-dragonfly.immich.svc.cluster.local:6379";
          DB_HOSTNAME = "{{ .Release.Name }}-postgresql";
          DB_USERNAME = "{{ .Values.postgresql.global.postgresql.auth.username }}";
          DB_DATABASE_NAME = "{{ .Values.postgresql.global.postgresql.auth.database }}";
          # TODO: -- You should provide your own secret outside of this helm-chart and use `postgresql.global.postgresql.auth.existingSecret` to provide credentials to the postgresql instance
          DB_PASSWORD = "{{ .Values.postgresql.global.postgresql.auth.password }}";
        };

        image.tag = "v1.119.0";
        immich = {
          metrics.enabled = true;
          persistence.library.existingClaim = "immich-pvc";
          configuration = {
            trash = {
              enabled = true;
              days = "30";
            };
          };
        };

        server = {
          enabled = true;
          image = {
            repository = "ghcr.io/immich-app/immich-server";
            pullPolicy = "IfNotPresent";
          };
          ingress.main = {
            enabled = false;
            annotations."nginx.ingress.kubernetes.io/proxy-body-size" = 0;
            hosts = [
              {
                host = "immich.local";
                paths = [ { path = "/"; } ];
              }
            ];
            tls = [ ];
          };
        };

        machine-learning.enabled = false;
      };
    };

    manifests.immich-dragonfly.content = {
      apiVersion = "dragonflydb.io/v1alpha1";
      kind = "Dragonfly";
      metadata = {
        name = "immich-dragonfly";
        namespace = "immich";
      };
      spec = {
        replicas = 1;
        resources = {
          requests = {
            cpu = "500m";
            memory = "500Mi";
          };
          limits = {
            cpu = "600m";
            memory = "750Mi";
          };
        };
      };
    };
  };
}
