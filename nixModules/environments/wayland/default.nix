{
  pkgs,
  inputs,
  wm,
  userConfig,
}: let
  inherit (userConfig) username colorscheme font;
in {
  imports = [
    (
      if wm == "Hyprland"
      then (import ./hyprland/default.nix {inherit inputs pkgs userConfig;})
      else if wm == "sway"
      then (import ./sway/default.nix {inherit inputs pkgs userConfig;})
      else []
    )
    (import ./waystatus/default.nix {inherit username colorscheme font;})
  ];

  environment.shellAliases = {
    obs = "env -u WAYLAND_DISPLAY obs";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland
    obs-studio
    inputs.seto.packages.${system}.default
    inputs.waystatus.packages.${system}.default
    (writeShellScriptBin "run_wm" ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      ${(
        if wm == "sway"
        then "exec sway --unsupported-gpu"
        else wm
      )}
      fi
    '')
  ];

  environment.loginShellInit = ''run_wm'';
}
