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
    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.moxwiki.gated then
            "moxwiki.i.${config.homelab.domain}"
          else
            "moxwiki.${config.homelab.domain}"
        else
          null;
      description = "Hostname for moxwiki ingress (defaults to moxwiki.i.<domain> if gated, moxwiki.<domain> otherwise)";
    };
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };
}
