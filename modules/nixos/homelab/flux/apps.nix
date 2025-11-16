{ ... }:
{
  services.k3s.manifests.flux-apps.content = [
    {
      apiVersion = "kustomize.toolkit.fluxcd.io/v1";
      kind = "Kustomization";
      metadata = {
        name = "apps";
        namespace = "flux-system";
      };
      spec = {
        interval = "5m";
        timeout = "10m";
        retryInterval = "1m";
        dependsOn = [
          { name = "namespaces"; }
          { name = "sources"; }
          { name = "config"; }
          { name = "core"; }
        ];
        path = "./kubernetes/apps";
        prune = true;
        force = true;
        sourceRef = {
          kind = "GitRepository";
          name = "flux-system";
        };
        decryption = {
          provider = "sops";
          secretRef = {
            name = "sops-age";
          };
        };
        postBuild = {
          substitute = { };
          substituteFrom = [
            {
              kind = "ConfigMap";
              name = "cluster-settings";
            }
            {
              kind = "Secret";
              name = "cluster-secrets";
            }
          ];
        };
        patches = [
          {
            target = {
              group = "kustomize.toolkit.fluxcd.io";
              version = "v1";
              kind = "Kustomization";
              labelSelector = "substitution.flux.home.arpa/disabled notin (true)";
            };
            patch = "apiVersion: kustomize.toolkit.fluxcd.io/v1\nkind: Kustomization\nmetadata:\n  name: not-used\nspec:\n  interval: 8m\n  timeout: 10m\n  retryInterval: 5m\n  force: true\n  prune: true\n  wait: true\n  sourceRef:\n    kind: GitRepository\n    name: flux-system\n  decryption:\n    provider: sops\n    secretRef:\n      name: sops-age\n  postBuild:\n    substituteFrom:\n      - kind: ConfigMap\n        name: cluster-settings\n      - kind: Secret\n        name: cluster-secrets";
          }
          {
            target = {
              group = "kustomize.toolkit.fluxcd.io";
              version = "v1";
              kind = "Kustomization";
              labelSelector = "kustomize.patches/append notin (true)";
            };
            patch = "apiVersion: kustomize.toolkit.fluxcd.io/v1\nkind: Kustomization\nmetadata:\n  name: not-used\nspec:\n  $patch: merge\n  patches:\n    - target:\n        group: helm.toolkit.fluxcd.io\n        version: v2\n        kind: HelmRelease\n        labelSelector: substitution.flux.home.arpa/disabled notin (true)\n      patch: |-\n        apiVersion: helm.toolkit.fluxcd.io/v2\n        kind: HelmRelease\n        metadata:\n          name: not-used\n        spec:\n          interval: 8m\n          timeout: 10m\n          chart:\n            spec:\n              interval: 15m\n          install:\n            crds: CreateReplace\n            createNamespace: true\n            remediation:\n              retries: 3\n          upgrade:\n            crds: CreateReplace\n            cleanupOnFail: true\n            remediation:\n              retries: 3";
          }
          {
            target = {
              group = "kustomize.toolkit.fluxcd.io";
              version = "v1";
              kind = "Kustomization";
              labelSelector = "kustomize.patches/append in (true)";
            };
            patch = "- op: add\n  path: /spec/patches/-\n  value:\n    target:\n      group: helm.toolkit.fluxcd.io\n      version: v2\n      kind: HelmRelease\n      labelSelector: substitution.flux.home.arpa/disabled notin (true)\n    patch: |-\n      apiVersion: helm.toolkit.fluxcd.io/v2\n      kind: HelmRelease\n      metadata:\n        name: not-used\n      spec:\n        interval: 8m\n        timeout: 10m\n        chart:\n          spec:\n            interval: 15m\n        install:\n          crds: CreateReplace\n          createNamespace: true\n          remediation:\n            retries: 3\n        upgrade:\n          crds: CreateReplace\n          cleanupOnFail: true\n          remediation:\n            retries: 3\n               \n";
          }
          {
            target = {
              group = "helm.toolkit.fluxcd.io";
              version = "v2";
              kind = "HelmRelease";
              labelSelector = "substitution.flux.home.arpa/disabled notin (true)";
            };
            patch = "apiVersion: helm.toolkit.fluxcd.io/v2\nkind: HelmRelease\nmetadata:\n  name: not-used\nspec:\n  interval: 8m\n  timeout: 10m\n  chart:\n    spec:\n      interval: 15m\n  install:\n    crds: CreateReplace\n    createNamespace: true\n    remediation:\n      retries: 3\n  upgrade:\n    crds: CreateReplace\n    cleanupOnFail: true\n    remediation:\n      retries: 3";
          }
        ];
      };
    }
  ];
}
