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
      default = pkgs.prismlauncher;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];
      persist.directories = [
        ".local/share/PrismLauncher"
      ];
    };
  };
}
