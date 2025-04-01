{ lib, system_type, ... }:
{
  programs.hyprland.enable = lib.mkDefault (system_type == "desktop");
}
