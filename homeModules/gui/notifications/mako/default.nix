{ config, lib, ... }:
{
  config = lib.mkIf (config.notifications.enable && config.notifications.program == "mako") {
    services.mako = {
      enable = true;
      defaultTimeout = 0;
      borderRadius = 5;
    };
  };
}
