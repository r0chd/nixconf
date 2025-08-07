{ pkgs, ... }:
let
  downloadHelmChart =
    {
      repo,
      chart,
      version,
      chartHash ? pkgs.lib.fakeHash,
    }:
    let
      pullFlags =
        if (pkgs.lib.hasPrefix "oci://" repo) then
          "${repo}/${chart}"
        else
          "--repo \"${repo}\" \"${chart}\"";
    in
    pkgs.stdenv.mkDerivation {
      name = "helm-chart-${repo}-${chart}-${version}";
      nativeBuildInputs = [ pkgs.cacert ];

      phases = [ "installPhase" ];
      installPhase = ''
        export HELM_CACHE_HOME="$TMP/.nix-helm-build-cache"

        OUT_DIR="$TMP/temp-chart-output"

        mkdir -p "$OUT_DIR"

        ${pkgs.kubernetes-helm}/bin/helm pull \
        --version "${version}" \
        ${pullFlags} \
        -d $OUT_DIR \
        --untar

        mv $OUT_DIR/${chart} "$out"
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = chartHash;
    };
in
{
  config.services.k3s.autoDeployCharts = {
    prometheus-crds = {
      package = downloadHelmChart {
        repo = "https://prometheus-community.github.io/helm-charts";
        chart = "prometheus-operator-crds";
        version = "22.0.2";
        chartHash = "sha256-QvO0bphwstuzXArvGl5mqa5B1ClwyGQtzv8UlqL9BUs=";
      };
      targetNamespace = "monitoring";
      createNamespace = true;
    };
    prometheus = {
      package = downloadHelmChart {
        repo = "https://prometheus-community.github.io/helm-charts";
        chart = "prometheus";
        version = "27.29.1";
        chartHash = "sha256-ohHcaVZb7UvGvFWCfxCfqQlZQ5hLY9+bdo8NTVs/+H8=";
      };
      targetNamespace = "monitoring";
      values = {
        fullnameOverride = "prometheus";
        defaultRules = {
          create = true;
          rules = {
            alertmanager = true;
            etcd = true;
            configReloaders = true;
            general = true;
            k8s = true;
            kubeApiserverAvailability = true;
            kubeApiserverBurnrate = true;
            kubeApiserverHistogram = true;
            kubeApiserverSlos = true;
            kubelet = true;
            kubeProxy = true;
            kubePrometheusGeneral = true;
            kubePrometheusNodeRecording = true;
            kubernetesApps = true;
            kubernetesResources = true;
            kubernetesStorage = true;
            kubernetesSystem = true;
            kubeScheduler = true;
            kubeStateMetrics = true;
            network = true;
            node = true;
            nodeExporterAlerting = true;
            nodeExporterRecording = true;
            prometheus = true;
            prometheusOperator = true;
          };
          alertmanager = {
            fullnameOverride = "alertmanager";
            enabled = true;
            ingress.enabled = false;
          };
          grafana = {
            enabled = true;
            fullnameOverride = "grafana";
            service.port = 3000;
            ingress = {
              enabled = true;
              ingressClassName = "ingress-nginx";
              annotations = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                "nginx.ingress.kubernetes.io/ssl-redirect" = true;
              };
              hosts = [ "grafana.your-domain.com" ];
              tls = [
                {
                  secretName = "ssl-cert";
                  hosts = [ "grafana.your-domain.com" ];
                }
              ];
            };
            forceDeployDatasources = false;
            forceDeployDashboards = false;
            defaultDashboardsEnabled = true;
            defaultDashboardsTimezone = "utc";
            serviceMonitor.enabled = true;
            admin = {
              existingSecret = "grafana-admin-credentials";
              userKey = "admin-user";
              passwordKey = "admin-password";
            };
          };
          prometheus = {
            enabled = true;
            prometheusSpec = {
              replicas = 1;
              replicaExternalLabelName = "replica";
              ruleSelectorNilUsesHelmValues = false;
              serviceMonitorSelectorNilUsesHelmValues = false;
              podMonitorSelectorNilUsesHelmValues = false;
              probeSelectorNilUsesHelmValues = false;
              retention = "6h";
              enableAdminAPI = true;
              walCompression = true;
              scrapeInterval = "30s";
              evaluationInterval = "30s";
            };
          };
          thanosRuler.enabled = true;
        };
      };
    };
  };
}
