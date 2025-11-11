{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.homelab.portfolio;
in
{
  imports = [
    ./namespace.nix
    ./server
    ./client
  ];

  options.homelab.portfolio = {
    enable = lib.mkEnableOption "portfolio";
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "portfolio.${config.homelab.domain}" else null;
      description = "Hostname for portfolio ingress (defaults to portfolio.<domain> if domain is set)";
    };
    githubApiTokenFile = lib.mkOption {
      type = types.str;
    };
    client.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
    server.resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s.secrets = [
      {
        name = "github-api";
        namespace = "portfolio";
        data."github_api" = cfg.githubApiTokenFile;
      }
    ];
  };
}
