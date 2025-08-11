{
  lib,
  profile,
  config,
  ...
}:
{
  programs.sway = {
    enable = lib.mkDefault (profile == "desktop");
    extraOptions = [ "--unsupported-gpu" ];
    extraPackages = [ ];
  };

  xdg.portal = lib.mkIf config.programs.sway.enable {
    enable = true;
    wlr.enable = lib.mkForce true;
  };
}
