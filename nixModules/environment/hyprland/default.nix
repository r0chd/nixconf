{
  lib,
  system_type,
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = lib.mkDefault (system_type == "desktop");
    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
