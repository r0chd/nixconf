{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts = {
    ingress-nginx = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://kubernetes.github.io/ingress-nginx";
        chart = "ingress-nginx";
        version = "4.13.0";
        chartHash = "sha256-Wqli6jwMbNnvHk57B/VxFOh37rg3JgNlzRVisBm5DHE=";
      };
      targetNamespace = "ingress-nginx";
      createNamespace = true;

      values = {
        controller = {
          ingressClassResource = {
            name = "ingress-nginx";
            enabled = true;
            default = true;
            controllerValue = "k8s.io/ingress.nginx";
            parameters = "{}";
          };
          admissionWebHooks = {
            enabled = false;
            patch.enabled = false;
          };
        };
        ingressClass = "ingress-nginx";
      };
    };

    externaldns-pihole = {
      name = "externaldns-pihole";
      targetNamespace = "pihole-system";
      repo = "oci://registry-1.docker.io/bitnamicharts/external-dns";
      version = "9.0.0";
      hash = "sha256-uanyYjrtTuErABr9qNn/z36QP3HV3Ew2h6oJvpB+FwA=";
      values = {
        provider = "pihole";
        policy = "upsert-only";
        txtOwnerId = "homelab";
        pihole.server = "http://pihole-web.pihole-system.svc.cluster.local";
        extraEnvVars = [
          {
            name = "EXTERNAL_DNS_PIHOLE_PASSWORD";
            valueFrom.secretKeyRef = {
              name = "pihole-password";
              key = "password";
            };
          }
        ];
        serviceAccount = {
          create = true;
          name = "external-dns";
        };
        ingressClassFilters = [ "ingress-nginx" ];
      };
    };
  };
}
