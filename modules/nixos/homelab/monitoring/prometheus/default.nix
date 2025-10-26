{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.prometheus;
  inherit (lib) types;
in
{
  options.homelab.prometheus = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
    domain = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config.services.k3s.autoDeployCharts = lib.mkIf cfg.enable {
    prometheus-crds = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://prometheus-community.github.io/helm-charts";
        chart = "prometheus-operator-crds";
        version = "22.0.2";
        chartHash = "sha256-NWeTgwFukR8/MuC0VnlrMFRmaWpFxtrIt5ewWMueaig=";
      };
      targetNamespace = "monitoring";
      createNamespace = true;
    };

    prometheus = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://prometheus-community.github.io/helm-charts";
        chart = "prometheus";
        version = "27.32.0";
        chartHash = "sha256-7picRoOCgfUUr+oBHCwPzOEd4GUj3q2frBZHlbcWYT0=";
      };
      targetNamespace = "monitoring";
      values = {
        server = {
          ingress = {
            enabled = cfg.domain != null;
            ingressClassName = "nginx";
            annotations = {
              "nginx.ingress.kubernetes.io/rewrite-target" = "/";
            };
            hosts = lib.optional (cfg.domain != null) cfg.domain;
          };
        };
      };
    };
  };
}
