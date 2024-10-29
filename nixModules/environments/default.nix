{ config, pkgs, inputs, conf, lib, }: {
  options.window-manager = {
    enable = lib.mkEnableOption "Enable";
    name = lib.mkOption { type = lib.types.enum [ "Hyprland" "sway" "niri" ]; };
  };
  imports = [
    (import ./hyprland { inherit inputs pkgs conf lib config; })
    (import ./sway { inherit conf lib config; })
    #(import ./niri { inherit inputs conf lib config; })
  ];

  config = lib.mkIf config.window-manager.enable {
    environment = {
      shellAliases.obs = "env -u WAYLAND_DISPLAY obs";
      loginShellInit =
        # bash
        ''
          if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
          ${(if config.window-manager.name == "sway" then
            "exec sway --unsupported-gpu"
          else
            config.window-manager.name)}
          fi
        '';
      systemPackages = with pkgs; [ wl-clipboard wayland obs-studio ];
    };
  };
}
