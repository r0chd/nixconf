{
  username,
  colorscheme,
  ...
}: let
  colors =
    if colorscheme == "catppuccin"
    then ["[166, 227, 161]" "[250, 180, 135]" "[202, 128, 128]" "[17, 18, 27]"]
    else [];
  getColor = index: "${builtins.elemAt colors index}";
in {
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
