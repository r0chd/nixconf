{ lib, pkgs, ... }:
{
  options.environment.notifications = {
    enable = lib.mkEnableOption "Enable notification daemon";
    program = lib.mkOption { type = lib.types.enum [ "mako" ]; };
  };
  imports = [ ./mako ];

  config.home.packages = with pkgs; [ libnotify ];
}
