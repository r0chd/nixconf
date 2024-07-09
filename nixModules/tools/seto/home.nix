{
  username,
  colorscheme,
  font,
  pkgs,
  inputs,
}: let
  colors =
    if colorscheme == "catppuccin"
    then ["#7287FD66" "#FFFFFF" "#DD7878" "#C5A8EB" "#40A02B"]
    else [];
  getColor = index: "${builtins.elemAt colors index}";
in {
  environment.systemPackages = with pkgs; [
    inputs.seto.packages.${system}.default
  ];
  home-manager.users."${username}".home.file.".config/seto/config.lua" = {
    text =
      /*
      lua
      */
      ''
        return {
        	background_color = "${getColor 0} #FF0000",
            font = {
            	color = "${getColor 1}",
            	highlight_color = "${getColor 2}",
            	size = 16,
            	family = "${font}",
            	weight = 1000,
            	offset = { 5, 5 },
            },
        	grid = {
        		color = "${getColor 3}",
        		line_width = 2,
        		size = { 80, 83 },
        		offset = { 0, 0 },
        		selected_color = "${getColor 4}",
        		selected_line_width = 2,
        	},
        	keys = {
        		search = "asdfghjkl",
        		bindings = {
        			z = { move = { -5, 0 } },
        			x = { move = { 0, 5 } },
        			n = { move = { 0, -5 } },
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
        			o = "border_select",
        			[8] = "remove",
        			q = "quit",
        		},
        	},
        }
      '';
  };
}
