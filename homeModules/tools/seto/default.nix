{ pkgs, inputs, config, lib, username, ... }:
let
  inherit (config) colorscheme font;
  inherit (colorscheme) text accent1 special warn;
in {
  options.seto = {
    enable = lib.mkEnableOption "Enable seto";
    font = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf config.seto.enable {
    environment.systemPackages = with pkgs; [ grim ];

    home-manager.users."${username}" = {
      imports = [ inputs.seto.homeManagerModules.default ];
      home.seto = {
        enable = true;
        package = inputs.seto.packages.${pkgs.system}.default;
        extraConfig = ''
          return {
              background_color = "#7287FD66";
              font = {
                  color = "${text}",
                  highlight_color = "${warn}",
                  family = "${font}",
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
          }'';
      };
    };
  };
}
