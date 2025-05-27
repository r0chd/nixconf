{
  mkShell,
  helm-ls,
  helmfile,
  wrapHelm,
  kubernetes-helm,
  kubernetes-helmPlugins,
}:
mkShell {
  buildInputs = [
    helm-ls
    helmfile
    (wrapHelm kubernetes-helm { plugins = [ kubernetes-helmPlugins.helm-diff ]; })
  ];
}
