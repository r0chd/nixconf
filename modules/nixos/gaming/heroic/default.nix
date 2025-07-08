{
  config,
  lib,
  pkgs,
  systemUsers,
  ...
}:
let
  cfg = config.gaming.heroic;
in
{
  options.gaming.heroic = {
    enable = lib.mkEnableOption "Enable heroic launcher";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.heroic;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      persist.users.directories = [
        ".config/heroic"
        "Games/Heroic"
      ];
    };
  };
}
