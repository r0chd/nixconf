{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts.glance = {
    package = pkgs.lib.downloadHelmChart {
      repo = "https://rubxkube.github.io/charts/";
      chart = "glance";
      version = "0.0.9";
      chartHash = "sha256-QvO0bphwstuzXArvGl5mqa5B1ClwyGQtzv8UlqL9BUs=";
    };
    targetNamespace = "glance";
    createNamespace = true;
    values.common = {
      name = "glance";
      service = {
        servicePort = 8080;
        containerPort = 8080;
      };
      deployment = {
        port = 8080;
        args = [
          "--config"
          "/mnt/glance.yml"
        ];
      };
      image = {
        repository = "glanceapp/glance";
        tag = "v0.8.3";
        pullPolicy = "IfNotPresent";
      };
      configMap = {
        enabled = true;
        data = [
          {
            name = "config";
            mountPath = "/mnt";
            data = [ { content.glance.yml = ./layout.nix; } ]; # TODO: rewrite in nix
          }
        ];
      };
      startupProbeEnabled = true;
      startupProbe = { };
      readinessProbeEnabled = false;
      readinessProbe = { };
      livenessProbeEnabled = false;
      livenessProbe = { };
      persistence = {
        enabled = true;
        volumes = [ ];
      };
      ingress = {
        enabled = true;
        hostName = "glance.your-domain.com";
        ingressClassName = "";
        extraLabels = { };
        tls = {
          enabled = true;
          secretName = "glance";
          annotations = { };
        };
      };
    };
  };
}
