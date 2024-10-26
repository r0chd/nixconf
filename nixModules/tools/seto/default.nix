{ pkgs, inputs, conf, lib, }:
let inherit (conf) username colorscheme;
in {
  options.seto.enable = lib.mkEnableOption "Enable seto";

  config = lib.mkIf conf.seto.enable {
    environment.systemPackages = with pkgs; [
      inputs.seto.packages.${system}.default
      grim
    ];

    home-manager.users."${username}".home.file.".config/seto/config.lua".text =
      let
        inherit (colorscheme) text accent1 special warn;
        inherit (conf) font;
        # lua
      in ''
        return {
            background_color = "#7287FD66";
            font = {
                color = "${text}",
                highlight_color = "${warn}",
                family = "${font}",
                weight = 50,
            },
            grid = {
                color = "${accent1}",
                size = { 60, 60 },
                selected_color = "${special}",
            },
            keys = {
                search = "asdfghjkl",
                bindings = {
                    z = { move = { -5, 0 } },
                    x = { move = { 0, -5 } },
                    n = { move = { 0, 5 } },
                    m = { move = { 5, 0 } },
                    Z = { resize = { -5, 0 } },
                    X = { resize = { 0, 5 } },
                    N = { resize = { 0, -5 } },
                    M = { resize = { 5, 0 } },
                    H = { move_selection = { -5, 0 } },
                    J = { move_selection = { 0, 5 } },
                    K = { move_selection = { 0, -5 } },
                    L = { move_selection = { 5, 0 } },
                    c = "cancel_selection",
                    o = "border_mode",
                },
            },
        }
      '';
  };
}
