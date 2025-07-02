{ config, lib, ... }:
let
  cfg = config.programs.bat;
in
{
  config = lib.mkIf cfg.enable { home.shellAliases.cat = "bat"; };
}
