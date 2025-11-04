{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
in
{
  imports = [
    ./namespace.nix
    ./server
    ./injector
    ./ui-service.nix
  ];

  options.homelab.vault = {
    enable = lib.mkEnableOption "vault k3s service";

    image = lib.mkOption {
      type = types.str;
      default = "vault:1.3.2";
      description = "Docker image for vault server";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of vault server replicas";
    };

    injector = {
      image = lib.mkOption {
        type = types.str;
        default = "hashicorp/vault-k8s:1.3.0";
        description = "Docker image for vault agent injector";
      };
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "vault.${config.homelab.domain}" else null;
      description = "Hostname for vault ingress (defaults to vault.<domain> if domain is set)";
    };
  };
}
