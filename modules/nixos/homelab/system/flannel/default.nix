{ ... }:
{
  config.services.k3s.autoDeployCharts.flannel = {
    name = "flannel";
    repo = "https://flannel-io.github.io/flannel";
    version = "0.27.3";
    hash = "sha256-On3FTOrpXBdAyNJi3DI0CY0IJ4yQ9S8sd+rW9jmm9xg=";
    targetNamespace = "system";
    extraFieldDefinitions = {
      podCidr = "10.244.0.0/16";
    };
  };
}
