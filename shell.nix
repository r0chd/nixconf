let
  pkgs = import (import ./npins).nixpkgs {
    config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "terraform" ];
  };
in
pkgs.mkShell {
  nativeBuildInputs =
    builtins.attrValues {
      inherit (pkgs)
        lix
        git
        npins
        nixd
        terraform-ls
        nixfmt
        home-manager
        nixos-rebuild
        jq
        ;
    }
    ++ [ (pkgs.terraform.withPlugins (p: builtins.attrValues { inherit (p) null external; })) ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${builtins.storePath pkgs.path}"
  '';
}
