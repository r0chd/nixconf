{ lib, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    #"pihole/password" = { };

    #"minio/credentials" = { };

    #alertmanager_webhook_url = { };

    #github_api = { };

    "garage/rpc-secret" = { };
    "garage/admin-token".sopsFile = ../../infra/fi-t/secrets/secrets.yaml;
    "garage/metrics-token" = { };

    #"vaultwarden_backup/access_key_id" = { };
    #"vaultwarden_backup/secret_access_key" = { };

    #"thanos/access_key" = { };
    #"thanos/secret_key" = { };

    #"quickwit/access_key_id" = { };
    #"quickwit/secret_access_key" = { };

    #"forgejo/access_key_id" = { };
    #"forgejo/secret_access_key" = { };
    #"forgejo/admin_password" = { };

    #"nextcloud/access_key_id" = { };
    #"nextcloud/secret_access_key" = { };
    #"nextcloud/admin_password" = { };

    #"github-client/client-secret" = { };

    #"oauth2-proxy/cookie-secret" = { };
    #"oauth2-proxy/client-secret" = { };

    #"vault_client_secret".sopsFile = ../../infra/kms/secrets/secrets.yaml;
  };

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  homelab = {
    enable = true;
    domain = "t.r0chd.pl";
    nodeType = "primary";

    storageClassName = "longhorn";

    system = {
      dragonfly.enable = true;
      longhorn.replicas = 1;
    };

    glance = {
      enable = true;
      ingressHost = "t.r0chd.pl";
    };
    moxwiki.enable = true;

    ingress.resources = {
      requests = {
        cpu = "100m";
        memory = "90Mi";
      };
    };

    garage = {
      enable = true;
      rpcSecret = config.sops.placeholder."garage/rpc-secret";
      adminToken = config.sops.placeholder."garage/admin-token";
      metricsToken = config.sops.placeholder."garage/metrics-token";
    };

    metallb.addresses = [
      "46.62.204.148/32"
      "172.31.1.100-172.31.1.150"
    ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
