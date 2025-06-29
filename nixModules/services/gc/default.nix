{ lib, config, ... }:
let
  cfg = config.services.gc;
in
{
  options.services.gc = {
    enable = lib.mkEnableOption "Garbage collector";
    keep = lib.mkOption {
      type = lib.types.int;
      default = 3;
    };
    interval = lib.mkOption {
      type = lib.types.int;
      default = 7;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh.clean = {
      enable = true;
      dates = "every ${toString cfg.interval} days";
      extraArgs = "--keep ${toString cfg.keep}";
    };
  };
}
