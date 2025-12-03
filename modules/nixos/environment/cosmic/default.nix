{ lib, profile, ... }:
{
  services.desktopManager.cosmic.enable = lib.mkDefault (profile == "desktop");
}
