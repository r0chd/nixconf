{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts.flannel = {
    package = pkgs.lib.downloadHelmChart {
      repo = "https://flannel-io.github.io/flannel/";
      chart = "flannel";
      version = "0.27.2";
      chartHash = "sha256-4wdu/qe2D5kGALpm8d60299CA+Yhh5+3YrD1wiA+AX8=";
    };
    targetNamespace = "kube-system";
    extraFieldDefinitions.set = [
      {
        name = "podCidr";
        value = "10.42.0.0/16";
      }
    ];
  };
}
