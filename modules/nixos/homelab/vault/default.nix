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
    ./ui-service.nix
  ];

  options.homelab.vault = {
    enable = lib.mkEnableOption "vault k3s service";

    image = lib.mkOption {
      type = types.str;
      default = "vault:1.13.3";
      description = "Docker image for vault server";
    };

    replicas = lib.mkOption {
      type = types.int;
      default = 1;
      description = "Number of vault server replicas";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "vault.${config.homelab.domain}" else null;
      description = "Hostname for vault ingress (defaults to vault.<domain> if domain is set)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
