{
  username,
  colorscheme,
  ...
}: let
  colors =
    if colorscheme == "lackluster"
    then ["[119, 136, 170]" "[175, 175, 175]" "[202, 128, 128]" "[0, 0, 0]"]
    else if colorscheme == "catppuccin"
    then ["[166, 227, 161]" "[201, 203, 255]" "[202, 128, 128]" "[23, 14, 31]"]
    else if colorscheme == "gruvbox"
    then ["[215, 153, 33]" "[151, 151, 26]" "[204, 36, 29]" "[102, 92, 84]"]
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
