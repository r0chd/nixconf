{ lib, system_type, ... }:
{
  programs.sway = {
    enable = lib.mkDefault (system_type == "desktop");
    extraOptions = [ "--unsupported-gpu" ];
  };
}
