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
  imports = [
    ./certificate.nix
    ./cluster-issuer.nix
  ];

  config.services.k3s.autoDeployCharts.cert-manager = {
    package = downloadHelmChart {
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
