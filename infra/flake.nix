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
                      carlpett_sops
                      ;
                  }
                  ++ [ prologin_garage ]
                ))
              ];

            shellHook = ''
              export AWS_ACCESS_KEY_ID="$(sops -d --extract '["minio"]["access_key_id"]' ./secrets/secrets.yaml)"
              export AWS_SECRET_ACCESS_KEY="$(sops -d --extract '["minio"]["secret_access_key"]' ./secrets/secrets.yaml)"
              export VAULT_ADDR="https://vault.r0chd.pl"
            '';
          };
        });
    };
}
