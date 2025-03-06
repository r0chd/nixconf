{ lib, ... }:
{
  options.environment.statusBar.enable = lib.mkEnableOption "Enable status bar";

  imports = [ ./waybar ];
}
