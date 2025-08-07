{
  config,
  pkgs,
  lib,
  ...
}:
let
  downloadHelmChart =
    {
      repo,
      chart,
      version,
      chartHash ? pkgs.lib.fakeHash,
    }:
    let
      pullFlags =
        if (pkgs.lib.hasPrefix "oci://" repo) then
          "${repo}/${chart}"
        else
          "--repo \"${repo}\" \"${chart}\"";
    in
    pkgs.stdenv.mkDerivation {
      name = "helm-chart-${repo}-${chart}-${version}";
      nativeBuildInputs = [ pkgs.cacert ];

      phases = [ "installPhase" ];
      installPhase = ''
        export HELM_CACHE_HOME="$TMP/.nix-helm-build-cache"

        OUT_DIR="$TMP/temp-chart-output"

        mkdir -p "$OUT_DIR"

        ${pkgs.kubernetes-helm}/bin/helm pull \
        --version "${version}" \
        ${pullFlags} \
        -d $OUT_DIR \
        --untar

        mv $OUT_DIR/${chart} "$out"
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = chartHash;
    };
  inherit (lib) types;
  cfg = config.homelab.immich;
in
{
  imports = [
    ./db.nix
    ./pvc.nix
  ];

  options.homelab.immich = {
    enable = lib.mkEnableOption "immich";
  };

  config.services.k3s.autoDeployCharts.immich = lib.mkIf cfg.enable {
    package = downloadHelmChart {
      repo = "https://immich-app.github.io/immich-charts";
      chart = "immich";
      version = "0.9.3";
      chartHash = "";
    };
    targetNamespace = "vaultwarden";
    createNamespace = true;

    values = {
      env = {
        REDIS_HOSTNAME = ''{{ printf "%s-redis-master" .Release.Name }}'';
        DB_HOSTNAME = "{{ .Release.Name }}-postgresql";
        DB_USERNAME = "{{ .Values.postgresql.global.postgresql.auth.username }}";
        DB_DATABASE_NAME = "{{ .Values.postgresql.global.postgresql.auth.database }}";
        # TODO: -- You should provide your own secret outside of this helm-chart and use `postgresql.global.postgresql.auth.existingSecret` to provide credentials to the postgresql instance
        DB_PASSWORD = "{{ .Values.postgresql.global.postgresql.auth.password }}";
        IMMICH_MACHINE_LEARNING_URL = ''{{ printf "http://%s-machine-learning:3003" .Release.Name }}'';
      };

      image.tag = "v1.119.0";
      immich = {
        metrics.enabled = true;
        persistence.library.existingClaim = "immich-pvc";
        configuration = {
          # trash:
          #   enabled: false
          #   days: 30
          # storageTemplate:
          #   enabled: true
          #   template: "{{y}}/{{y}}-{{MM}}-{{dd}}/{{filename}}"
        };
      };

      postgresql = {
        enabled = true;
        image = {
          repository = "tensorchord/pgvecto-rs";
          tag = "pg14-v0.2.0@sha256:739cdd626151ff1f796dc95a6591b55a714f341c737e27f045019ceabf8e8c52";
        };
        global.postgresql.auth = {
          username = "immich";
          database = "immich";
          password = "immich";
        };
        primary = {
          containerSecurityContext.readOnlyRootFilesystem = false;
          initdb.scripts."create-extensions.sql" = ''
            CREATE EXTENSION cube;
            CREATE EXTENSION earthdistance;
            CREATE EXTENSION vectors;
          '';
        };
      };

      redis = {
        enabled = true;
        architecture = "standalone";
        auth.enabled = false;
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

      machine-learning = {
        enabled = true; # TODO: optionally enable
        image = {
          repository = "ghcr.io/immich-app/immich-machine-learning";
          pullPolicy = "IfNotPresent";
        };
        env.TRANSFORMERS_CACHE = "/cache";
        persistence.cache = {
          # TODO: optionally enable and cfg.size
          enabled = true;
          size = "10Gi";
          type = "emptyDir";
          accessMode = "ReadWriteMany";
          storageClass = "immich-pvc";
        };
      };
    };
  };
}
