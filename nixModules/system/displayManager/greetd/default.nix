{
  lib,
  config,
  ...
}:
let
  cfg = config.system.displayManager;
in
{
  imports = [ ./tuigreet ];

  config = lib.mkIf (cfg.enable && cfg.variant == "greetd") {
    services.greetd.enable = true;

    programs.tuigreet = {
      enable = true;
      time = {
        enable = true;
        format = "DD.MM.YYY";
      };
      greeting = {
        enable = true;
        text = "Kill yourself";
      };
      asterisks.enable = true;
      user = {
        menu.enable = true;
        remember = true;
        rememberSession = true;
      };
      power = {
        shutdown = "systemctl poweroff";
        reboot = "systemctl reboot";
      };
    };
  };
}
