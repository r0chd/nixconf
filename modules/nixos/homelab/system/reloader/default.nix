{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts = {
    reloader = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://stakater.github.io/stakater-charts";
        chart = "reloader";
        version = "2.2.2";
        chartHash = "sha256-KIjExc9olb1HnA7HSbSLoT930AQPqWk+rfH+AjUNCVQ=";
      };
      targetNamespace = "system";
      createNamespace = true;

      values = {
        reloader = {
          autoReloadAll = true;
          reloadOnCreate = true;
          reloadOnDelete = true;
        };
      };
    };
  };
}
