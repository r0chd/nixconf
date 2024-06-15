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
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec sway
      end
    ''
    else ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        exec sway
      fi
    '';

  security.polkit.enable = true;
}
