{
  lib,
  config,
  ...
}:
let
  cfg = config.system.gc;
in
{
  options.system.gc = {
    enable = lib.mkEnableOption "Garbage collector";
    interval = lib.mkOption {
      type = lib.types.int;
      default = 7;
    };
  };

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than ${toString config.system.gc.interval}d";
    };
  };
}
