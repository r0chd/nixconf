{
  pkgs,
  inputs,
  config,
  std,
  lib,
  ...
}:
{
  config = lib.mkIf (config.wallpaper.enable && config.wallpaper.program == "ruin") {
    impermanence.persist.directories = [ ".config/ruin/images" ];
    home = {
      packages = with pkgs; [ inputs.ruin.packages.${system}.default ];

      file.".config/ruin/colorschemes.yaml" = {
        text =
          let
            inherit (std.conversions) hexToRGBString;
          in
          ''
            nix:
              charging: [${hexToRGBString ", " "A6E3A1"}]
              default: [${hexToRGBString ", " "C9CBFF"}]
              low_battery: [${hexToRGBString ", " "CA8080"}]
              background: [${hexToRGBString ", " "170E1F"}]
          '';
      };
    };
  };
}
