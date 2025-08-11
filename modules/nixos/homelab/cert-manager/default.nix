{ pkgs, ... }:
{
  imports = [
    ./certificate.nix
    ./cluster-issuer.nix
  ];

  config.services.k3s.autoDeployCharts.cert-manager = {
    package = pkgs.lib.downloadHelmChart {
      repo = "https://charts.jetstack.io";
      chart = "cert-manager";
      version = "1.17.2";
      chartHash = "sha256-8d/BPet3MNGd8n0r5F1HEW4Rgb/UfdtwqSFuUZTyKl4=";
    };
    targetNamespace = "cert-manager";
    createNamespace = true;
    values.crds = {
      enabled = true;
      keep = true;
    };
  };
}
