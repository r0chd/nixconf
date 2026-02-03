{
  inputs.parent.url = "path:/var/lib/nixconf";

  outputs =
    { parent, ... }:
    {
      devShells =
        let
          inherit (parent.inputs.nixpkgs) lib;
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
          forAllSystems =
            function:
            parent.inputs.nixpkgs.lib.genAttrs systems (
              system:
              let
                pkgs = import parent.inputs.nixpkgs {
                  inherit system;
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (lib.getName pkg) [
                      "vault"
                    ];
                };
              in
              function pkgs
            );
        in
        forAllSystems (pkgs: {
          default = pkgs.mkShell {
            buildInputs =
              let
                svalabs_forgejo = pkgs.terraform-providers.mkProvider {
                  owner = "svalabs";
                  repo = "terraform-provider-forgejo";
                  rev = "v1.1.0";
                  version = "1.1.0";
                  hash = "sha256-kT19Vwcv6TplWdqmj44WMfzqm4AzKiMGoogxcxx8d+Q=";
                  vendorHash = "sha256-nszKWUQ0zTksErD+4z1es1K30fcDS0nTjHV5ktdwsUg=";
                  homepage = "https://registry.terraform.io/providers/svalabs/forgejo";
                };
                prologin_garage = pkgs.terraform-providers.mkProvider {
                  owner = "prologin";
                  repo = "terraform-provider-garage";
                  rev = "v0.0.1";
                  version = "0.0.1";
                  hash = "sha256-JNeTJ5nt8IvYk9M8fUEiGTLUDd9QHS6PeBwWDjRzx4g=";
                  vendorHash = "sha256-6PXFDwQRPJU6+X1pUuzIaTiQNVPJjOUDMsnDXBivO5A=";
                  homepage = "https://registry.terraform.io/providers/prologin/garage";
                };
              in
              builtins.attrValues {
                inherit (pkgs)
                  vault
                  terraform-ls
                  jq
                  ;
              }
              ++ [
                (pkgs.opentofu.withPlugins (
                  p:
                  builtins.attrValues {
                    inherit (p)
                      hashicorp_null
                      hashicorp_external
                      hashicorp_aws
                      hashicorp_vault
                      hashicorp_kubernetes
                      carlpett_sops
                      cloudflare_cloudflare
                      ;
                  }
                  ++ [
                    prologin_garage
                    svalabs_forgejo
                  ]
                ))
              ];

            shellHook = ''
              export VAULT_ADDR="https://vault.r0chd.pl"
            '';
          };
        });
    };
}
