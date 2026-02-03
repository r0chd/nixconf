{ lib, config, ... }:
let
  cfg = config.homelab.forgejo;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s = {
      autoDeployCharts.forgejo-runner = {
        name = "forgejo-runner";
        repo = "oci://codeberg.org/wrenix/helm-charts/forgejo-runner";
        version = "0.6.21";
        hash = "sha256-hMZSwOdZkGJdz+tXsk3+KZMZjj+Bvop+x9GYWswAU7E=";
        targetNamespace = "forgejo";

        values = {
          inherit (cfg.runner) resources;

          replicaCount = 1;
          runner = {
            config = {
              existingInitSecret = "forgejo-runner-token";
              file = {
                log = {
                  level = "info";
                };
                runner = {
                  file = ".runner";
                  capacity = 1;
                  envs = {
                    DOCKER_HOST = "tcp://127.0.0.1:2376";
                    DOCKER_TLS_VERIFY = 1;
                    DOCKER_CERT_PATH = "/certs/client";
                  };
                };
                container = {
                  network = "host";
                  docker_host = "automount";
                  enable_ipv6 = false;
                  privileged = true;
                  options = "-v /certs/client:/certs/client";
                  valid_volumes = [ "/certs/client" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
