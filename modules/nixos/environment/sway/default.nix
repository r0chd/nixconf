{ lib, profile, ... }:
{
  programs.sway = {
    enable = lib.mkDefault (profile == "desktop");
    extraOptions = [ "--unsupported-gpu" ];
    extraPackages = [ ];
  };
}
