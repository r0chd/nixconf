{ config, lib, ... }:
let
  cfg = config.homelab.auth;
  inherit (lib) types;
in
{
  imports = [
    ./vault
    ./dex
    ./oauth2-proxy
    ./namespace.nix
  ];

  options.homelab.auth = {
    enable = lib.mkEnableOption "dex";

    clientSecret = lib.mkOption {
      type = types.str;
    };

    oauth2ProxyCookie = lib.mkOption {
      type = types.str;
    };

    github = {
      enable = lib.mkEnableOption "github oauth2";
      clientId = lib.mkOption {
        type = types.str;
      };
      clientSecret = lib.mkOption {
        type = types.str;
      };

      org = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      teams = lib.mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
      };

      users = lib.mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s.secrets = [
      {
        metadata = {
          name = "oauth2-proxy-cookie";
          namespace = "auth";
        };
        stringData = {
          OAUTH2_PROXY_COOKIE_SECRET = cfg.oauth2ProxyCookie;
        };
      }
      {
        metadata = {
          name = "dex-oauth2-client-secret";
          namespace = "auth";
        };
        stringData = {
          OAUTH2_PROXY_CLIENT_SECRET = cfg.clientSecret;
        };
      }
    ]
    ++ lib.optionals cfg.github.enable [
      {
        metadata = {
          name = "github-client-credentials";
          namespace = "auth";
        };
        stringData = {
          GITHUB_CLIENT_SECRET = cfg.github.clientSecret;
        };
      }
    ];
  };
}
