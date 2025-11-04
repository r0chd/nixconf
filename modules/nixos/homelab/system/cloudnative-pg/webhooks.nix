{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.cloudnative-pg.enable) {
    services.k3s.manifests.cnpg-webhooks.content = [
      # MutatingWebhookConfiguration
      {
        apiVersion = "admissionregistration.k8s.io/v1";
        kind = "MutatingWebhookConfiguration";
        metadata.name = "cnpg-mutating-webhook-configuration";
        webhooks = [
          {
            name = "mbackup.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/mutate-postgresql-cnpg-io-v1-backup";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "backups" ];
              }
            ];
          }
          {
            name = "mcluster.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/mutate-postgresql-cnpg-io-v1-cluster";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "clusters" ];
              }
            ];
          }
          {
            name = "mscheduledbackup.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/mutate-postgresql-cnpg-io-v1-scheduledbackup";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "scheduledbackups" ];
              }
            ];
          }
        ];
      }
      # ValidatingWebhookConfiguration
      {
        apiVersion = "admissionregistration.k8s.io/v1";
        kind = "ValidatingWebhookConfiguration";
        metadata.name = "cnpg-validating-webhook-configuration";
        webhooks = [
          {
            name = "vbackup.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/validate-postgresql-cnpg-io-v1-backup";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "backups" ];
              }
            ];
          }
          {
            name = "vcluster.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/validate-postgresql-cnpg-io-v1-cluster";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "clusters" ];
              }
            ];
          }
          {
            name = "vpooler.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/validate-postgresql-cnpg-io-v1-pooler";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "poolers" ];
              }
            ];
          }
          {
            name = "vscheduledbackup.cnpg.io";
            admissionReviewVersions = [ "v1" ];
            clientConfig = {
              service = {
                name = "cnpg-webhook-service";
                namespace = "system";
                path = "/validate-postgresql-cnpg-io-v1-scheduledbackup";
              };
            };
            failurePolicy = "Fail";
            sideEffects = "None";
            rules = [
              {
                apiGroups = [ "postgresql.cnpg.io" ];
                apiVersions = [ "v1" ];
                operations = [
                  "CREATE"
                  "UPDATE"
                ];
                resources = [ "scheduledbackups" ];
              }
            ];
          }
        ];
      }
    ];
  };
}
