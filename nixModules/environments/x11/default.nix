{
  userConfig,
  pkgs,
  inputs,
  wm,
}: let
  inherit (userConfig) browser colorscheme terminal username;
in {
  imports = [
    (
      if wm == "i3"
      then (import ./i3/home.nix {inherit inputs pkgs browser colorscheme terminal username;})
      else []
    )
  ];
  services.xserver = {
    enable = true;
  };
}
