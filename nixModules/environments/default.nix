{
  pkgs,
  inputs,
  wm,
  conf,
  lib,
  std,
}: {
  imports = [
    (
      if wm == "Hyprland"
      then (import ./hyprland {inherit inputs pkgs conf lib;})
      else if wm == "sway"
      then (import ./sway {inherit inputs pkgs conf lib;})
      else []
    )
  ];

  environment = {
    shellAliases.obs = "env -u WAYLAND_DISPLAY obs";
    loginShellInit =
      /*
      bash
      */
      ''
        if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        ${(
          if wm == "sway"
          then "exec sway --unsupported-gpu"
          else wm
        )}
        fi
      '';
    systemPackages = with pkgs; [
      wl-clipboard
      wayland
      obs-studio
    ];
  };
}
