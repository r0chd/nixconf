{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts = {
    ingress-nginx = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://kubernetes.github.io/ingress-nginx";
        chart = "ingress-nginx";
        version = "4.13.0";
        chartHash = "sha256-c8kjHcOr9p+YrwLqih6qqizePlOqd16xxbz3mw1Pn3g=";
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
  };
}
