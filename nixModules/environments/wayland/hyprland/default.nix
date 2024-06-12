{
  term,
  pkgs,
  inputs,
  username,
  shell,
  colorscheme,
  ...
}: {
  imports = [
    (import ./home.nix {inherit inputs username term colorscheme;})
  ];

  environment.loginShellInit =
    if shell == "fish"
    then ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        Hyprland
      end
    ''
    else ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        Hyprland
      fi
    '';

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    hyprcursor
  ];
}
