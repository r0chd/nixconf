{
  lib,
  config,
  pkgs,
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
          name = lib.mkOption { type = lib.types.str; };
          namespace = lib.mkOption { type = lib.types.nullOr lib.types.str; };
          data = lib.mkOption {
            type = lib.types.attrsOf lib.types.path;
            description = "Attribute set where keys are secret keys and values are paths to files containing the secret values";
          };
        };
      }
    );
    default = [ ];
  };

  config = lib.mkIf (builtins.length cfg.secrets > 0) {
    systemd.services = lib.listToAttrs (
      lib.map (secret: {
        name = "k3s-secret-${secret.name}";
        value = {
          enable = true;
          description = "k3s secret for ${secret.name}";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            After = [ "k3s.service" ];
            Requires = [ "k3s.service" ];
          };
          environment.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
          script = ''
            ${lib.optionalString (secret.namespace != null) ''
              ${pkgs.kubectl}/bin/kubectl get namespace ${secret.namespace} >/dev/null 2>&1 || \
              ${pkgs.kubectl}/bin/kubectl create namespace ${secret.namespace}
            ''}

            ${pkgs.kubectl}/bin/kubectl apply -f - <<EOF
            apiVersion: v1
            kind: Secret
            metadata:
              name: ${secret.name}
              ${lib.optionalString (secret.namespace != null) "namespace: ${secret.namespace}"}
            type: Opaque
            stringData:
              ${lib.concatStringsSep "\n  " (
                lib.mapAttrsToList (key: path: "${key}: $(cat ${path})") secret.data
              )}
            EOF
          '';
        };
      }) cfg.secrets
    );
  };
}
