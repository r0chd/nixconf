{ ... }:
{
  config.services.k3s.autoDeployCharts = {
    ingress-nginx = {
      name = "ingress-nginx";
      repo = "https://kubernetes.github.io/ingress-nginx";
      version = "4.13.0";
      hash = "sha256-c8kjHcOr9p+YrwLqih6qqizePlOqd16xxbz3mw1Pn3g=";
      targetNamespace = "ingress-nginx";
      createNamespace = true;

      values = {
        controller = {
          ingressClassResource = {
            name = "nginx";
            enabled = true;
            default = true;
            controllerValue = "k8s.io/ingress-nginx";
          };
          admissionWebHooks = {
            enabled = false;
            patch.enabled = false;
          };
          service = {
            type = "LoadBalancer";
          };
        };
        ingressClass = "nginx";
      };
    };
  };
}
