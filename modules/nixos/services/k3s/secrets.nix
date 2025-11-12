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
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
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

  config = {
    #sops.templates = builtins.listToAttrs (
    #  builtins.map (v: {
    #    name = "${v.name}-test";
    #    value = {
    #      path = "/var/lib/rancher/k3s/server/manifests/${v.name}-test.yaml";
    #      content = v.data;
    #    };
    #  }) (builtins.filter (v: v.enable) cfg.secrets)
    #);

    systemd.services = lib.listToAttrs (
      lib.map (secret: {
        name = "k3s-secret-${secret.name}";
        value = {
          inherit (secret) enable;
          description = "k3s secret for ${secret.name}";
          after = [ "k3s.service" ];
          requires = [ "k3s.service" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
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
            data:
              ${lib.concatStringsSep "\n  " (
                lib.mapAttrsToList (
                  key: path: "${key}: $(${pkgs.coreutils}/bin/cat ${path} | ${pkgs.coreutils}/bin/base64 -w 0)"
                ) secret.data
              )}
            EOF
          '';
        };
      }) cfg.secrets
    );
  };
}
