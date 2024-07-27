{
  pkgs,
  inputs,
  conf,
  std,
}: let
  inherit (conf) username colorscheme;
in {
  environment.systemPackages = with pkgs; [inputs.ruin.packages.${system}.default];
  home-manager.users."${username}".home.file.".config/ruin/colorschemes.yaml" = {
    text = let
      inherit (colorscheme) error special background1 accent2;
      inherit (std.conversions) hexToRGBString;
    in ''
      nix:
        charging: [${hexToRGBString ", " special}]
        default: [${hexToRGBString ", " accent2}]
        low_battery: [${hexToRGBString ", " error}]
        background: [${hexToRGBString ", " background1}]
    '';
  };
}
