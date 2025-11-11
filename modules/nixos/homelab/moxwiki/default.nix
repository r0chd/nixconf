{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./deployment.nix
    ./ingress.nix
    ./namespace.nix
    ./service.nix
  ];

  options.homelab.moxwiki = {
    enable = lib.mkEnableOption "moxwiki";
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "moxwiki.${config.homelab.domain}" else null;
      description = "Hostname for moxwiki ingress (defaults to moxwiki.<domain> if domain is set)";
    };
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
