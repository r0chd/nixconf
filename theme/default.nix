{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.stylix.theme;

  themeSettings = {
    gruvbox = {
      image = pkgs.fetchurl {
        url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/finalizer.png";
        sha256 = "0i8vcjcplacd7lj9fksb8bp1hxkazf3jrfg54hw3lvh8bjqkwn13";
      };
      cursor = {
        name = "Capitaine Cursors (Gruvbox)";
        package = pkgs.capitaine-cursors-themed;
        size = lib.mkDefault 36;
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
    };

    catppuccin-mocha = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-catppuccin-mocha.png";
        sha256 = "ce562a4a27794352f9b14ac072f47eeda3768c89a2ba847d832801464f31f56a";
      };
      cursor = {
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "catppuccin-mocha-mauve-cursors";
        size = lib.mkDefault 36;
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };
  };
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
    description = "Select a theme configuration for Stylix";
  };

  config = lib.mkIf (cfg != null) {
    stylix =
      let
        theme = themeSettings.${cfg};
      in
      {
        inherit (theme) image cursor base16Scheme;
        polarity = "dark";
      };
  };
}
