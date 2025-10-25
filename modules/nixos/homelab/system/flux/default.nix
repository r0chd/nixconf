_:
{
  config.services.k3s.autoDeployCharts.flux = {
    name = "flux2";
    repo = "https://fluxcd-community.github.io/helm-charts";
    version = "2.16.4";
    hash = "sha256-PP7TrOSytaZnsXiG1tZI19l+Fn8Ti8XDeQKpt8wgID8=";
    targetNamespace = "system";
  };
}
