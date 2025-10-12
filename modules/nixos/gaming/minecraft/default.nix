{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gaming.minecraft;
in
{
  options.gaming.minecraft = {
    enable = lib.mkEnableOption "Enable minecraft";
    package = lib.mkOption {
      type = lib.types.package;
      default = (
        pkgs.prismlauncher.override {
          additionalLibs = builtins.attrValues {
            inherit (pkgs)
              nss
              nspr
              cef-binary
              libgbm
              ;
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
      ];
      persist.users.directories = [ ".local/share/PrismLauncher" ];
    };
  };
}
