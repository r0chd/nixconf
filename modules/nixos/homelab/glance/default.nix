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
  config.services.k3s.autoDeployCharts.glance = {
    package = downloadHelmChart {
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
