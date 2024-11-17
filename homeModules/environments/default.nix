{ config, pkgs, inputs, lib, username, window-manager, ... }: {
  options = {
    window-manager = {
      enable = lib.mkEnableOption "Enable";
      backend = lib.mkOption {
        type = lib.types.enum [ "X11" "Wayland" "none" ];
        default = "none";
      };
      name =
        lib.mkOption { type = lib.types.enum [ "Hyprland" "sway" "niri" ]; };
    };
  };

  imports = [
    (import ./wayland {
      inherit inputs pkgs lib config username window-manager;
    })
    (import ./x11 { inherit inputs pkgs lib config username window-manager; })
  ];
}
