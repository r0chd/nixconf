{
  username,
  colorscheme,
  pkgs,
  inputs,
}: let
  colors =
    if colorscheme == "catppuccin"
    then ["[166, 227, 161]" "[201, 203, 255]" "[202, 128, 128]" "[23, 14, 31]"]
    else [];
  getColor = index: "${builtins.elemAt colors index}";
in {
  environment.systemPackages = with pkgs; [inputs.ruin.packages.${system}.default];
  home-manager.users."${username}".home.file.".config/ruin/colorschemes.yaml" = {
    text = ''
      nix:
        charging: ${getColor 0}
        default: ${getColor 1}
        low_battery: ${getColor 2}
        background: ${getColor 3}
    '';
  };
}
