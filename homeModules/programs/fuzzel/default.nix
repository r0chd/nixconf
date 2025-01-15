{ config, lib, ... }:
{
  programs.fuzzel.settings.main.launch-prefix = lib.mkIf (
    config.environment.session == "Wayland"
  ) "uwsm app -t service --";
}
