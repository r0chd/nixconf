{ system_type, lib, ...}: {
  programs.niri.enable = lib.mkDefault (system_type == "desktop");
}
