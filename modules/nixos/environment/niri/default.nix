{
  lib,
  profile,
  ...
}:
{
  programs.niri.enable = lib.mkDefault (profile == "desktop");
}
