{ config, lib, ... }:
let
  cfg = config.homelab.database.cloudnative-pg;
in
{
  config = lib.mkIf config.homelab.enable {
    services.k3s.manifests.cnpg-databases.content = lib.flatten (
      lib.mapAttrsToList (clusterName: clusterCfg: [
        {
          apiVersion = "postgresql.cnpg.io/v1";
          kind = "Cluster";
          metadata = {
            name = clusterName;
            inherit (clusterCfg) namespace;
          };
          spec = {
            inherit (clusterCfg) instances;
            inherit (clusterCfg) minSyncReplicas;
            inherit (clusterCfg) maxSyncReplicas;
            imageCatalogRef = {
              apiGroup = "postgresql.cnpg.io";
              kind = "ClusterImageCatalog";
              name = "postgresql";
              major = lib.toInt clusterCfg.postgresVersion;
            };
            postgresql.parameters = clusterCfg.postgresParameters;
            monitoring.enablePodMonitor = clusterCfg.monitoring.enablePodMonitor;
            bootstrap = lib.optionalAttrs (clusterCfg.bootstrap.initdb.database != null) {
              initdb = {
                database = clusterCfg.bootstrap.initdb.database;
                owner = clusterCfg.bootstrap.initdb.owner;
                secret.name = clusterCfg.bootstrap.initdb.secret.name;
              };
            };
            storage = {
              storageClass = clusterCfg.storage.storageClass;
              resizeInUseVolumes = clusterCfg.storage.resizeInUseVolumes;
              size = clusterCfg.storage.size;
            };
            walStorage = {
              storageClass = clusterCfg.walStorage.storageClass;
              resizeInUseVolumes = clusterCfg.walStorage.resizeInUseVolumes;
              size = clusterCfg.walStorage.size;
            };
            resources = {
              requests = {
                cpu = clusterCfg.resources.requests.cpu;
                memory = clusterCfg.resources.requests.memory;
              };
              limits =
                lib.optionalAttrs (clusterCfg.resources.limits.cpu != null) {
                  cpu = clusterCfg.resources.limits.cpu;
                }
                // lib.optionalAttrs (clusterCfg.resources.limits.memory != null) {
                  memory = clusterCfg.resources.limits.memory;
                };
            };
          };
        }

        (lib.optional clusterCfg.backup.enable {
          apiVersion = "postgresql.cnpg.io/v1";
          kind = "ScheduledBackup";
          metadata = {
            name = clusterName;
            inherit (clusterCfg) namespace;
          };
          spec = {
            schedule = clusterCfg.backup.schedule;
            immediate = clusterCfg.backup.immediate;
            backupOwnerReference = "self";
            cluster.name = clusterName;
          };
        })

        (lib.optionals clusterCfg.networkPolicies.enable [
          (lib.optional (clusterCfg.networkPolicies.allowFromApps != [ ]) {
            apiVersion = "networking.k8s.io/v1";
            kind = "NetworkPolicy";
            metadata = {
              name = "${clusterName}-allow-apps";
              inherit (clusterCfg) namespace;
            };
            spec = {
              podSelector.matchLabels."cnpg.io/cluster" = clusterName;
              ingress = [
                {
                  from = map (appName: {
                    podSelector.matchLabels."app.kubernetes.io/name" = appName;
                  }) clusterCfg.networkPolicies.allowFromApps;
                  ports = [
                    {
                      port = 5432;
                    }
                  ];
                }
              ];
            };
          })

          (lib.optional clusterCfg.networkPolicies.allowOperator {
            apiVersion = "networking.k8s.io/v1";
            kind = "NetworkPolicy";
            metadata = {
              name = "${clusterName}-allow-operator";
              inherit (clusterCfg) namespace;
            };
            spec = {
              podSelector.matchLabels."cnpg.io/cluster" = clusterName;
              ingress = [
                {
                  from = [
                    {
                      namespaceSelector.matchLabels."kubernetes.io/metadata.name" = "cnpg-system";
                      podSelector.matchLabels."app.kubernetes.io/name" = "cloudnative-pg";
                    }
                  ];
                  ports = [
                    { port = 8000; }
                    { port = 5432; }
                  ];
                }
              ];
            };
          })

          (lib.optional clusterCfg.networkPolicies.allowPrometheus {
            apiVersion = "networking.k8s.io/v1";
            kind = "NetworkPolicy";
            metadata = {
              name = "${clusterName}-allow-monitoring";
              inherit (clusterCfg) namespace;
            };
            spec = {
              podSelector.matchLabels."cnpg.io/cluster" = clusterName;
              ingress = [
                {
                  from = [
                    {
                      podSelector.matchLabels."app.kubernetes.io/name" = "prometheus";
                    }
                  ];
                  ports = [
                    {
                      port = 9187;
                    }
                  ];
                }
              ];
            };
          })

          (lib.optional clusterCfg.networkPolicies.allowInterNode {
            apiVersion = "networking.k8s.io/v1";
            kind = "NetworkPolicy";
            metadata = {
              name = "${clusterName}-allow-inter-node";
              inherit (clusterCfg) namespace;
            };
            spec = {
              podSelector.matchLabels."cnpg.io/cluster" = clusterName;
              ingress = [
                {
                  from = [
                    {
                      podSelector.matchLabels."cnpg.io/cluster" = clusterName;
                    }
                  ];
                  ports = [
                    {
                      port = 5432;
                    }
                  ];
                }
              ];
            };
          })

          (lib.optional (clusterCfg.networkPolicies.allowFromNamespaces != [ ]) {
            apiVersion = "networking.k8s.io/v1";
            kind = "NetworkPolicy";
            metadata = {
              name = "${clusterName}-allow-namespaces";
              inherit (clusterCfg) namespace;
            };
            spec = {
              podSelector.matchLabels."cnpg.io/cluster" = clusterName;
              ingress = [
                {
                  from = map (nsName: {
                    namespaceSelector.matchLabels."kubernetes.io/metadata.name" = nsName;
                  }) clusterCfg.networkPolicies.allowFromNamespaces;
                  ports = [
                    {
                      port = 5432;
                    }
                  ];
                }
              ];
            };
          })
        ])
      ]) cfg.clusters
    );
  };
}
