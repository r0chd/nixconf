{ pkgs }:
pkgs.mkShell {
  buildInputs =
    builtins.attrValues {
      inherit (pkgs)
        helm-ls
        helmfile
        terraform-ls
        jq
        nixd
        nixfmt-rfc-style
        yaml-language-server
        prettier
        kustomize
        ;
    }
    ++ [
      (pkgs.terraform.withPlugins (p: builtins.attrValues { inherit (p) null external; }))
      (pkgs.wrapHelm pkgs.kubernetes-helm {
        plugins = builtins.attrValues { inherit (pkgs.kubernetes-helmPlugins) helm-diff; };
      })
    ];
}
