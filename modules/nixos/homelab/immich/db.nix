{ config, lib, ... }:
let
  cfg = config.homelab.immich;
in
{
  config.services.k3s.autoDeployCharts.immich.extraDeploy = lib.mkIf cfg.enable [
    {
      apiVersion = "postgresql.cnpg.io/v1";
      kind = "Cluster";
      metadata.name = "immich-postgres";
      spec = {
        imageName = "ghcr.io/tensorchord/cloudnative-pgvecto.rs:16.5-v0.3.0@sha256:be3f025d79aa1b747817f478e07e71be43236e14d00d8a9eb3914146245035ba";
        instances = 1;
        postgresql.shared_preload_libraries = [ "vectors.so" ];
        managed.roles = [
          {
            name = "immich";
            superuser = true;
            login = true;
          }
        ];

        bootstrap.initdb = {
          database = "immich";
          owner = "immich";
          secret.name = "immich-postgres-user";
          import = {
            type = "microservice";
            databases = [ "immich" ];
            source.externalCluster = "cluster-pg96";
          };
          postInitSQL = [
            ''CREATE EXTENSION IF NOT EXISTS "vectors"''
            ''CREATE EXTENSION IF NOT EXISTS "cube" CASCADE''
            ''CREATE EXTENSION IF NOT EXISTS "earthdistance" CASCADE''
          ];
        };

        storage = {
          size = "4Gi"; # TODO: make it an option
          storageClass = config.homelab.storageClass;
        };

        externalClusters = [
          {
            name = "cluster-pg96";
            connectionParameters = {
              host = "immich-postgresql.immich.svc.cluster.local";
              user = "immich";
              dbname = "immich";
            };
            password = {
              name = "immich-postgres-user";
              key = "password";
            };
          }
        ];
      };
    }
  ];
}
