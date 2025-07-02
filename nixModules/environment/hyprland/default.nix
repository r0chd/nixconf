{
  lib,
  profile,
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = lib.mkDefault (profile == "desktop");
  };
}
