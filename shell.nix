{ pkgs }:
with pkgs;
mkShell {
  buildInputs = [
    helm-ls
    helmfile
    (wrapHelm kubernetes-helm {
      plugins = [
        kubernetes-helmPlugins.helm-diff
        kubernetes-helmPlugins.helm-secrets
      ];
    })
  ];
}
