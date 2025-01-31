{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.environment;
in
{
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (cfg.session == "Wayland") {
    nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

    home = {
      packages = with pkgs; [
        wl-clipboard
        wayland
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
