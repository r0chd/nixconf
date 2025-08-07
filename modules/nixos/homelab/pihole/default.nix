{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.pihole;
  inherit (lib) types;

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
  options.homelab.pihole = {
    passwordFile = lib.mkOption { type = types.path; };
    dns = lib.mkOption { type = types.str; };
    domain = lib.mkOption { type = types.str; };
    webLoadBalancerIP = lib.mkOption { type = types.str; };
    dnsLoadBalancerIP = lib.mkOption { type = types.str; };
    adlists = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    replicas = lib.mkOption {
      type = types.int;
      default = 1;
    };
  };

  config.services.k3s = {
    autoDeployCharts.pihole = {
      package = downloadHelmChart {
        repo = "https://mojo2600.github.io/pihole-kubernetes";
        chart = "pihole";
        version = "2.18.0";
        chartHash = "sha256-zqTKKe2f9G85TRH1o4H8XjQws9EsSujwtbtIj0p7E5w=";
      };
      targetNamespace = "pihole-system";
      createNamespace = true;
      values = {
        DNS1 = [ cfg.dns ];
        persistentVolumeClaim = {
          enabled = true;
          storageClass = "openebs-hostpath";
        };
        ingress = {
          enabled = true;
          annotations = {
            "nginx.ingress.kubernetes.io/ssl-redirect" = true;
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP";
          };
          hosts = [ cfg.domain ];
          tls = [
            {
              secretName = "pihole-tls-secret";
              hosts = [ cfg.domain ];
            }
          ];
        };
        serviceWeb = {
          loadBalancerIP = cfg.webLoadBalancerIP;
          annotations."metallb.universe.tf/allow-shared-ip" = "pihole-svc";
          type = "LoadBalancer";
        };
        serviceDns = {
          loadBalancerIP = cfg.dnsLoadBalancerIP;
          annotations."metallb.universe.tf/allow-shared-ip" = "pihole-svc";
          type = "LoadBalancer";
        };
        replicaCount = cfg.replicas;
        admin = {
          enabled = true;
          existingSecret = "pihole-password";
          passwordKey = "password";
          annotations = { };
        };
        adlists = cfg.adlists;
      };
    };
    secrets = [
      {
        name = "pihole-password";
        namespace = "pihole-system";
        data = {
          "pihole-password" = cfg.passwordFile;
        };
      }
    ];
  };
}
