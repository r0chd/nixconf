{ config, lib, ... }:
let
  cfg = config.homelab.ingress-nginx;
in
{
  options.homelab.ingress-nginx = {
    serviceType = lib.mkOption {
      type = lib.types.enum [ "LoadBalancer" "NodePort" ];
      default = "LoadBalancer";
      description = "Service type for ingress-nginx. Use NodePort for VPS without LoadBalancer support.";
    };
    nodePortHttp = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = "NodePort for HTTP (80). If null, Kubernetes will assign automatically.";
    };
    nodePortHttps = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = "NodePort for HTTPS (443). If null, Kubernetes will assign automatically.";
    };
  };

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
            type = cfg.serviceType;
          } // lib.optionalAttrs (cfg.serviceType == "NodePort") {
            nodePorts = {
              http = cfg.nodePortHttp;
              https = cfg.nodePortHttps;
            };
          };
        };
        ingressClass = "nginx";
      };
    };
  };
}
