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

    "minio/credentials" = { };

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

    "nextcloud/access_key_id" = { };
    "nextcloud/secret_access_key" = { };
    "nextcloud/admin_password" = { };

    "github-client/client-secret" = { };

    "oauth2-proxy/cookie-secret" = { };
    "oauth2-proxy/client-secret" = { };

    "vault_client_secret".sopsFile = ../../infra/kms/secrets/secrets.yaml;
  };

  services = {
    minio = {
      enable = true;
      region = "eu-central-1";
      rootCredentialsFile = config.sops.secrets."minio/credentials".path;
    };
  };

  services.k3s.manifests = {
    minio-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "minio-external";
          namespace = "default";
        };
        spec = {
          type = "ClusterIP";
          ports = [
            {
              port = 9000;
              name = "s3";
            }
            {
              port = 9001;
              name = "console";
            }
          ];
        };
      }
    ];
    minio-external-endpoints.content = [
      {
        apiVersion = "v1";
        kind = "Endpoints";
        metadata = {
          name = "minio-external";
          namespace = "default";
        };
        subsets = [
          {
            addresses = [
              {
                ip = "157.180.30.62";
              }
            ];
            ports = [
              {
                port = 9000;
                name = "s3";
              }
              {
                port = 9001;
                name = "console";
              }
            ];
          }
        ];
      }
    ];
    minio-ingress.content = [
      {
        apiVersion = "networking.k8s.io/v1";
        kind = "Ingress";
        metadata = {
          name = "minio-ingress";
          namespace = "default";
          annotations."cert-manager.io/cluster-issuer" = "letsencrypt";
        };
        spec = {
          ingressClassName = "nginx";
          tls = [
            {
              hosts = [
                "s3.minio.r0chd.pl"
                "console.minio.r0chd.pl"
              ];
              secretName = "minio-tls";
            }
          ];
          rules = [
            {
              host = "s3.minio.r0chd.pl";
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "minio-external";
                        port.number = 9000;
                      };
                    };
                  }
                ];
              };
            }
            {
              host = "console.minio.r0chd.pl";
              http = {
                paths = [
                  {
                    path = "/";
                    pathType = "Prefix";
                    backend = {
                      service = {
                        name = "minio-external";
                        port.number = 9001;
                      };
                    };
                  }
                ];
              };
            }
          ];
        };
      }
    ];
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

    ingress.resources = {
      requests = {
        cpu = "100m";
        memory = "90Mi";
      };
    };

    #storageClassName = "openebs-zfs-localpv";

    metallb.addresses = [
      "157.180.30.62/32"
      "172.31.1.100-172.31.1.150"
    ];
    system = {
      dragonfly.enable = true;
      zfs-localpv.poolname = "zroot";
      #pihole = {
      #  dns = "172.31.1.1";
      #  passwordFile = config.sops.secrets."pihole/password".path;
      #  adlists = [ "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" ];
      #  webLoadBalancerIP = "172.31.1.102";
      #  dnsLoadBalancerIP = "172.31.1.103";
      #};
    };

    portfolio.enable = true;
    nextcloud = {
      enable = true;
      s3 = {
        access_key_id = config.sops.placeholder."nextcloud/access_key_id";
        secret_access_key = config.sops.placeholder."nextcloud/secret_access_key";
      };
      admin = {
        username = "admin";
        password = config.sops.placeholder."nextcloud/admin_password";
      };
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
      vault = {
        enable = true;
        clientSecret = config.sops.placeholder."vault_client_secret";
      };

      github = {
        enable = true;
        clientId = "Ov23lioBYc4Eh1GmUp6T";
        clientSecret = config.sops.placeholder."github-client/client-secret";
        orgs = [
          {
            name = "r0chd-homelab";
          }
        ];
      };
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
        passwordAuth.enable = false;
      };
      kube-web = {
        enable = true;
        resources = {
          limits.memory = "100Mi";
          requests = {
            cpu = "5m";
            memory = "100Mi";
          };
        };
        gated = true;
      };
      kube-ops = {
        enable = true;
        resources = {
          limits = {
            cpu = "200m";
            memory = "100Mi";
          };
          requests = {
            cpu = "50m";
            memory = "50Mi";
          };
        };
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
      kuvasz = {
        enable = false;
        gated = true;
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
