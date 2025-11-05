{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.minio-client;
  inherit (lib) types;
in
{
  options.programs.minio-client = {
    enable = lib.mkEnableOption "minio-client";
    package = lib.mkPackageOption pkgs "minio-client" { };

    settings = {
      version = lib.mkOption {
        type = types.str;
        default = "10";
        description = "Configuration version for minio client";
      };

      aliases = lib.mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              url = lib.mkOption {
                type = types.str;
                description = "Minio server URL";
                example = "https://minio.example.com";
              };

              accessKey = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Access key";
              };

              secretKey = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Secret key";
              };

              api = lib.mkOption {
                type = types.str;
                default = "S3v4";
                description = "API signature version";
              };

              path = lib.mkOption {
                type = types.str;
                default = "auto";
                description = "Path style";
              };
            };
          }
        );
        default = { };
        description = "Minio server aliases";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    sops.templates."minio-client" = {
      content = lib.generators.toJSON { } cfg.settings;
      path = "${config.home.homeDirectory}/.mc/config.json";
    };
  };
}
