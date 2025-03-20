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
    default = config.services.moxnotify.enable;
    type = lib.types.bool;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ moxctl ];
  };
}
