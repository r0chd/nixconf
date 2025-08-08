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
        -d $OUT_DIR

        mv $OUT_DIR/${chart}.tgz "$out"
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = chartHash;
    };
in
{
  config.services.k3s.autoDeployCharts.flannel = {
    package = downloadHelmChart {
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
