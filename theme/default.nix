{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.stylix.theme;
in
{
  options.stylix.theme = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "gruvbox"
        "catppuccin-mocha"
      ]
    );
    default = null;
  };

  config = lib.mkIf (cfg != null) {
    stylix = {
      image =
        if cfg == "gruvbox" then
          pkgs.fetchurl {
            url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/finalizer.png";
            sha256 = "0i8vcjcplacd7lj9fksb8bp1hxkazf3jrfg54hw3lvh8bjqkwn13";
          }
        else if cfg == "catppuccin-mocha" then
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish-catppuccin-mocha.png";
            sha256 = "ce562a4a27794352f9b14ac072f47eeda3768c89a2ba847d832801464f31f56a";
          }
        else
          throw "Unreachable";

      base16Scheme =
        if cfg == "gruvbox" then
          "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml"
        else if cfg == "catppuccin-mocha" then
          "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml"
        else
          throw "Unreachable";

      polarity = "dark";
    };
  };
}
