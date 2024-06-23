{
  inputs,
  config,
  ...
}: let
  inherit (config) username terminal shell colorscheme browser;
in {
  imports = [
    (import ./home.nix {inherit inputs username terminal colorscheme browser;})
  ];

  environment.loginShellInit =
    if shell == "fish"
    then ''
      if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
        exec sway --unsupported-gpu
      end
    ''
    else ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec sway --unsupported-gpu
      fi
    '';

  security.polkit.enable = true;
}
