{
  system_type,
  lib,
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = lib.mkDefault (system_type == "desktop");
    package = pkgs.niri;
  };
}
