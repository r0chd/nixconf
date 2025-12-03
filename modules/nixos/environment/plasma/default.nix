{ lib, profile, ... }:
{
  services.desktopManager.plasma6.enable = lib.mkDefault (profile == "desktop");
}
