{
  profile,
  lib,
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = lib.mkDefault (profile == "desktop");
    package = pkgs.niri-unstable;
  };
}
