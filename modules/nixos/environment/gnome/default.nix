{ lib, profile, ... }:
{
  services.desktopManager.gnome.enable = lib.mkDefault (profile == "desktop");
}
