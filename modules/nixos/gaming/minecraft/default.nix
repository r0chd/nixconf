{
  lib,
  config,
  pkgs,
  systemUsers,
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
    environment = {
      systemPackages = [ cfg.package ];
      persist.users.directories = [ ".local/share/PrismLauncher" ];
    };
  };
}
