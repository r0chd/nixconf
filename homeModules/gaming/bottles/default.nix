{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gaming.bottles;
in
{
  options.gaming.bottles = {
    enable = lib.mkEnableOption "Enable heroic launcher";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bottles;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
