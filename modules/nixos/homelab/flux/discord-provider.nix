{ config, ... }:
let
  cfg = config.homelab.flux;
in
{
  services.k3s = {
    manifests."flux-discord-provider" = {
      enable = cfg.webhook != null;
      content = [
        {
          apiVersion = "notification.toolkit.fluxcd.io/v1beta3";
          kind = "Provider";
          metadata = {
            name = "discord";
            namespace = "default";
          };
          spec = {
            type = "discord";
            secretRef.name = "discord-webhook";
          };
        }
        {
          apiVersion = "notification.toolkit.fluxcd.io/v1beta3";
          kind = "Alert";
          metadata = {
            name = "discord-alert";
            namespace = "default";
          };
          spec = {
            providerRef = {
              name = "discord";
            };
            eventSeverity = "info";
            eventSources = [
              {
                kind = "Kustomization";
                name = "*";
                namespace = "flux-system";
              }
              {
                kind = "Bucket";
                name = "*";
                namespace = "flux-system";
              }
              {
                kind = "GitRepository";
                name = "*";
                namespace = "flux-system";
              }
            ];
          };
        }
      ];
    };
    secrets = [
      {
        metadata = {
          name = "discord-webhook";
          namespace = "default";
        };
        stringData.address = cfg.webhook;
      }
    ];
  };
}
