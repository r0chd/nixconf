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

      orgs = lib.mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              name = lib.mkOption {
                type = types.str;
              };
              teams = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
            };
          }
        );
        default = [ ];
      };
    };

    vault = {
      clientSecret = lib.mkOption {
        type = types.str;
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
          name = "oauth2-proxy-credentials";
          namespace = "auth";
        };
        stringData = {
          "client-id" = "oauth2-proxy";
          "client-secret" = cfg.clientSecret;
          "cookie-secret" = cfg.oauth2ProxyCookie;
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
      {
        metadata = {
          name = "vault-client-credentials";
          namespace = "auth";
        };
        stringData = {
          GITHUB_CLIENT_SECRET = cfg.vault.clientSecret;
        };
      }
    ];
  };
}
