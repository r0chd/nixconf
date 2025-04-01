{ lib, config, ... }:
let
  cfg = config.system.gc;
in
{
  options.system.gc = {
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
      dates = "weekly";
      extraArgs = "--keep ${toString cfg.keep} --keep-since ${toString cfg.interval}d";
    };
  };
}
