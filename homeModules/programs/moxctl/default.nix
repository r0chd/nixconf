{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.moxctl;
in
{
  options.programs.moxctl.enable = lib.mkOption {
    default = config.environment.notify.enable;
    type = lib.types.bool;
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ moxctl ]; };
}
