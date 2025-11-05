{ config, lib, ... }:
let
  cfg = config.homelab.ingress-nginx;
  inherit (lib) types;
in
{
  options.homelab.ingress-nginx = {
    loadBalancerIP = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "LoadBalancer IP address for ingress-nginx service. Should be a public IP from MetalLB address pool.";
      example = "157.180.30.62";
    };
    hostNetwork = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable hostNetwork mode for ingress-nginx. Use this when the public IP is already assigned to the node's interface. This makes ingress-nginx bind directly to the host's network.";
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
          hostNetwork = cfg.hostNetwork;
          service = lib.mkIf (!cfg.hostNetwork) {
            type = "LoadBalancer";
            loadBalancerIP = lib.mkIf (cfg.loadBalancerIP != null) cfg.loadBalancerIP;
          };
        };
        ingressClass = "nginx";
      };
    };
  };
}
