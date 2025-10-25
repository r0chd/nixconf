{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.minio;
  inherit (lib) types;

  # Check if any aliases use secret files
  hasSecretFiles = lib.any (alias: alias.accessKeyFile != null || alias.secretKeyFile != null) (
    lib.attrValues cfg.settings.aliases
  );

  # Build alias config, handling secret files
  buildAlias = name: alias: {
    inherit (alias) url;
    accessKey =
      if alias.accessKeyFile != null then
        "%{${name}_access_key}" # Template placeholder
      else
        alias.accessKey;
    secretKey =
      if alias.secretKeyFile != null then
        "%{${name}_secret_key}" # Template placeholder
      else
        alias.secretKey;
    inherit (alias) api;
    inherit (alias) path;
  };

  # Generate config structure
  configData = {
    version = cfg.settings.version;
    aliases = lib.mapAttrs buildAlias cfg.settings.aliases;
  };
in
{
  options.programs.minio = {
    enable = lib.mkEnableOption "minio";

    settings = {
      version = lib.mkOption {
        type = types.int;
        default = 10;
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
                description = "Access key (use accessKeyFile for secrets)";
              };

              secretKey = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Secret key (use secretKeyFile for secrets)";
              };

              accessKeyFile = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "SOPS secret key for access key";
                example = "minio.access_key";
              };

              secretKeyFile = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "SOPS secret key for secret key";
                example = "minio.secret_key";
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
    home.packages = [ pkgs.minio-client ];

    sops.templates = lib.mkIf hasSecretFiles {
      "minio-config.json" = {
        content = lib.generators.toJSON { } configData;
      };
    };

    home.file.".mc/config.json" =
      if hasSecretFiles then
        {
          source = config.sops.templates."minio-config.json".path;
        }
      else
        {
          text = lib.generators.toJSON { } configData;
        };

    # Method 2: Alternative using activation script (if sops.templates doesn't work)
    # Uncomment this and comment out the sops.templates approach above if needed
    /*
      home.activation.minioConfig = lib.mkIf hasSecretFiles (lib.hm.dag.entryAfter ["writeBoundary"] ''
        # Create mc config directory
        mkdir -p $HOME/.mc

        # Generate config JSON with secrets substituted
        ${pkgs.jq}/bin/jq -n '${lib.generators.toJSON {} configData}' \
          ${lib.concatStringsSep " " (lib.mapAttrsToList (var: secretPath:
            "| .aliases.${lib.strings.removeSuffix "_access_key" (lib.strings.removeSuffix "_secret_key" var)}.${if lib.strings.hasSuffix "_access_key" var then "accessKey" else "secretKey"} = \"$(cat ${secretPath})\""
          ) templateVars)} \
          > $HOME/.mc/config.json

        chmod 600 $HOME/.mc/config.json
      '');
    */
  };
}
