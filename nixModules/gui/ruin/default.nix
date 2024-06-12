{
  username,
  colorscheme,
  ...
}: {
  home-manager.users."${username}".home.file.".config/ruin/colorschemes.yaml" = {
    text = (
      if colorscheme == "lackluster"
      then ''
        nixos:
          charging: [99, 68, 37]
          default: [175, 175, 175]
          low_battery: [202, 128, 128]
          background: [0, 0, 0]
      ''
      else if colorscheme == "catppuccin"
      then ''
        nixos:
          charging: [166, 227, 161]
          default: [201, 203, 255]
          low_battery: [202, 128, 128]
          background: [23, 14, 31]
      ''
      else ''''
    );
  };
}
