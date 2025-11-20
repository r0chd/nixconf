{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-serviceaccount".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "vault";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
        };
      }
    ];
  };
}
