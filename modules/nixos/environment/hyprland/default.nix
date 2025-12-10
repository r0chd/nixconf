{
  lib,
  profile,
  ...
}:
{
  programs.hyprland.enable = lib.mkDefault (profile == "desktop");
}
