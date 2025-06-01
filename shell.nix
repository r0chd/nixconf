{ pkgs }:
with pkgs;
mkShell {
  buildInputs = [
    helm-ls
    helmfile
    terraform-ls
    jq
    kustomize
    kustomize-sops
    #(terraform.withPlugins (p: [
    #p.null
    #p.external
    #]))
    (wrapHelm kubernetes-helm {
      plugins = [
        kubernetes-helmPlugins.helm-diff
        kubernetes-helmPlugins.helm-secrets
      ];
    })
  ];
}
