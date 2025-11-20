{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-disruptionbudget".content = [
      {
        apiVersion = "policy/v1";
        kind = "PodDisruptionBudget";
        metadata = {
          name = "vault";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        spec = {
          maxUnavailable = 0;
          selector.matchLabels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
            component = "server";
          };
        };
      }
    ];
  };
}
