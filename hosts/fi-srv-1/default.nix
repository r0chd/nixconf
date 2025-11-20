{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    #"pihole/password" = { };

    alertmanager_webhook_url = { };

    github_api = { };

    "garage/rpc-secret" = { };
    "garage/admin-token".sopsFile = ../../infra/fi/secrets/secrets.yaml;
    "garage/metrics-token" = { };

    "grafana/username" = { };
    "grafana/password" = { };

    "vaultwarden_backup/access_key_id" = { };
    "vaultwarden_backup/secret_access_key" = { };

    "thanos/access_key" = { };
    "thanos/secret_key" = { };

    "quickwit/access_key_id" = { };
    "quickwit/secret_access_key" = { };

    "forgejo/access_key_id" = { };
    "forgejo/secret_access_key" = { };

    "forgejo/admin_password" = { };

    "github-client/client-secret" = { };

    "oauth2-proxy/cookie-secret" = { };
    "oauth2-proxy/client-secret" = { };
  };

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  services.k3s.extraFlags = [
    "--tls-san 157.180.30.62"
    "--tls-san 10.0.0.3"
  ];

  homelab = {
    enable = true;
    domain = "r0chd.pl";

    nodeType = "primary";

    #storageClassName = "openebs-zfs-localpv";

    metallb.addresses = [
      "157.180.30.62/32"
      "172.31.1.100-172.31.1.150"
    ];
    system = {
      dragonfly.enable = true;
      zfs-localpv.poolname = "zroot";
      reloader.enable = true;
      #pihole = {
      #  dns = "172.31.1.1";
      #  passwordFile = config.sops.secrets."pihole/password".path;
      #  adlists = [ "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" ];
      #  webLoadBalancerIP = "172.31.1.102";
      #  dnsLoadBalancerIP = "172.31.1.103";
      #};
    };

    garage = {
      enable = true;
      rpcSecret = config.sops.placeholder."garage/rpc-secret";
      adminToken = config.sops.placeholder."garage/admin-token";
      metricsToken = config.sops.placeholder."garage/metrics-token";
    };

    vaultwarden = {
      enable = true;
      db.backup = {
        enable = true;
        accessKeyId = config.sops.placeholder."vaultwarden_backup/access_key_id";
        secretAccessKey = config.sops.placeholder."vaultwarden_backup/secret_access_key";
      };
    };

    forgejo = {
      enable = true;
      admin = {
        username = "r0chd";
        email = "oskarrochowiak@gmail.com";
        password = config.sops.placeholder."forgejo/admin_password";
      };
      s3 = {
        access_key_id = config.sops.placeholder."forgejo/access_key_id";
        secret_access_key = config.sops.placeholder."forgejo/secret_access_key";
      };
    };
    moxwiki.enable = true;

    glance = {
      enable = true;
      ingressHost = "r0chd.pl";
    };
    auth = {
      enable = true;
      github = {
        enable = true;
        clientId = "Iv23lizZfPiAiIbzNLmS";
        clientSecret = config.sops.placeholder."github-client/client-secret";
        org = "mox-desktop";
      };
      dex.ingressHost = "dex-test.r0chd.pl";
      clientSecret = config.sops.placeholder."oauth2-proxy/client-secret";
      oauth2ProxyCookie = config.sops.placeholder."oauth2-proxy/cookie-secret";
    };

    monitoring = {
      prometheus = {
        enable = true;
        gated = true;
      };
      alertmanager = {
        enable = true;
        gated = true;
        discordWebhookUrl = config.sops.placeholder.alertmanager_webhook_url;
      };
      thanos = {
        enable = true;
        gated = true;
        bucket = "thanos";
        access_key = config.sops.placeholder."thanos/access_key";
        secret_key = config.sops.placeholder."thanos/secret_key";
      };
      grafana = {
        enable = true;
        gated = true;
        username = "r0chd";
        password = config.sops.placeholder."grafana/password";
      };
      kube-web = {
        enable = true;
        gated = true;
      };
      kube-ops = {
        enable = true;
        gated = true;
      };
      kube-resource-report = {
        enable = true;
        gated = true;
      };
      vector.enable = true;
      quickwit = {
        enable = true;
        gated = true;
        s3 = {
          access_key_id = config.sops.placeholder."quickwit/access_key_id";
          secret_access_key = config.sops.placeholder."quickwit/secret_access_key";
        };
        retention = {
          period = "7 days";
          schedule = "daily";
        };
      };
    };
  };

  networking = {
    hostId = "662febd7";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
}
