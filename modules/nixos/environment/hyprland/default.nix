{
  config,
  lib,
  profile,
  ...
}:
let
  cfg = config.programs.hyprland;
in
{
  programs.hyprland = {
    enable = lib.mkDefault (profile == "desktop");
  };

  nix.settings = lib.mkIf cfg.enable {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
