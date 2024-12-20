{ config, lib, ... }:
let
  cfg = config.programs.lsd;
in
{
  config = lib.mkIf cfg.enable {
    programs.lsd.enableAliases = true;
  };
}
