{
  pkgs,
  inputs,
  config,
  std,
  lib,
  ...
}:
let
  inherit (config) colorscheme;
in
{
  config = lib.mkIf (config.wallpaper.enable && config.wallpaper.program == "ruin") {
    impermanence.persist.directories = [ ".config/ruin/images" ];
    home = {
      packages = with pkgs; [ inputs.ruin.packages.${system}.default ];

      file.".config/ruin/colorschemes.yaml" = {
        text =
          let
            inherit (colorscheme)
              error
              special
              background1
              accent2
              ;
            inherit (std.conversions) hexToRGBString;
          in
          ''
            nix:
              charging: [${hexToRGBString ", " special}]
              default: [${hexToRGBString ", " accent2}]
              low_battery: [${hexToRGBString ", " error}]
              background: [${hexToRGBString ", " background1}]
          '';
      };
    };
  };
}
