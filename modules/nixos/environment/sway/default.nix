{ lib, profile, ... }:
{
  programs.sway = {
    enable = lib.mkDefault (profile == "desktop");
    package = null;
    extraOptions = [ "--unsupported-gpu" ];
    extraPackages = [ ];
  };
}
