# Example:
#
# services.k3s.secrets = [
#   {
#     metadata = {
#       name = "grafana-secret";
#       namespace = "monitoring";
#     };
#     stringData = {
#       username = "admin";
#       password = config.sops.placeholder."grafana/password";
#     };
#   }
# ];

{
  lib,
  config,
  ...
}:
let
  cfg = config.services.k3s;
in
{
  options.services.k3s.secrets = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          metadata = {
            name = lib.mkOption { type = lib.types.str; };
            namespace = lib.mkOption { type = lib.types.nullOr lib.types.str; };
          };
          stringData = lib.mkOption {
            type = lib.types.anything;
          };
        };
      }
    );
    default = [ ];
  };

  config = {
    sops.templates = lib.listToAttrs (
      map (secret: {
        name = "${secret.metadata.name}";
        value = {
          content = builtins.toJSON {
            apiVersion = "v1";
            kind = "Secret";
            inherit (secret) metadata;
            inherit (secret) stringData;
          };
          path = "/var/lib/rancher/k3s/server/manifests/${secret.metadata.name}.json";
        };
      }) cfg.secrets
    );

    #system.postDeploy =
    #  let
    #    declaredSecrets = map (s: s.metadata.name) cfg.secrets;
    #  in
    #  lib.optionalString (cfg.secrets != [ ])
    #    # bash
    #    ''
    #      for f in /var/lib/rancher/k3s/server/manifests/*.json; do
    #        name=$(basename "$f" .json)
    #        if ! [[ " ${declaredSecrets}[*] " =~ " $name " ]]; then
    #          echo "Removing stale secret: $f"
    #          rm -f "$f"
    #        fi
    #      done
    #    '';
  };
}
