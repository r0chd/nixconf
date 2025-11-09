# 1. mc alias set myminio http://localhost:9000 minioadmin minioadmin
# 2. mc mb myminio/mybucket
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
    "minio/credentials" = { };
  };

  networking = {
    hostId = "662febd7";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  services = {
    tailscale.enable = lib.mkForce false;
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
                ip = "46.62.204.148";
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
                "s3.minio.kms.r0chd.pl"
                "console.minio.kms.r0chd.pl"
              ];
              secretName = "minio-tls";
            }
          ];
          rules = [
            {
              host = "s3.minio.kms.r0chd.pl";
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
              host = "console.minio.kms.r0chd.pl";
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

  homelab = {
    enable = true;
    domain = "kms.r0chd.pl";
    #storageClassName = "openebs-zfs-localpv";

    metallb.addresses = [
      "46.62.204.148/32"
      "172.31.1.100-172.31.1.150"
    ];
    system = {
      zfs-localpv.poolname = "zroot";
      reloader.enable = true;
    };

    kube-resource-report.enable = true;

    vault = {
      enable = true;
      proxy.enable = true;
    };
  };

  system.fileSystem = "zfs";

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
}
