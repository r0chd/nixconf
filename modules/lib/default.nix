config: [
  (_final: prev: {
    lib = prev.lib // {
      onGnome =
        let
          cfg = config.programs;
        in
        cfg.gnome.enable;

      downloadHelmChart =
        {
          repo,
          chart,
          version,
          chartHash ? prev.lib.fakeHash,
        }:
        let
          pullFlags =
            if (prev.lib.hasPrefix "oci://" repo) then
              "${repo}/${chart}"
            else
              "--repo \"${repo}\" \"${chart}\"";
        in
        prev.stdenv.mkDerivation {
          name = "helm-chart-${repo}-${chart}-${version}";
          nativeBuildInputs = [ prev.cacert ];
          phases = [ "installPhase" ];
          installPhase = ''
            export HELM_CACHE_HOME="$TMP/.nix-helm-build-cache"
            OUT_DIR="$TMP/temp-chart-output"
            mkdir -p "$OUT_DIR"
            ${prev.kubernetes-helm}/bin/helm pull \
            --version "${version}" \
            ${pullFlags} \
            -d $OUT_DIR
            # Remove --untar to keep as .tgz file
            cp $OUT_DIR/${chart}-${version}.tgz "$out"
          '';
          outputHashMode = "flat"; # Changed from "recursive" since we're copying a single file
          outputHashAlgo = "sha256";
          outputHash = chartHash;
        };
    };
  })
]
