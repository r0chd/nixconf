{
  config,
  pkgs,
  inputs,
  std,
  lib,
  ...
}:
let
  inherit (config) colorscheme;
in
{
  config = lib.mkIf (config.statusBar.enable && config.statusBar.program == "waystatus") {
    home = {
      packages = with pkgs; [ inputs.waystatus.packages.${system}.default ];
      file = {
        ".config/waystatus/style.css" = {
          text = ''
            * {
                font-family: "JetBrainsMono Nerd Font Mono";
                font-size: 16px;
                font-weight: bold;
                color: #FFFFFF;
                background-color: rgba(0, 0, 0, 0);
                margin-bottom: 10px;
            }

            backlight {
                margin-left: 25px;
                margin-right: 10px;
            }

            audio {
                margin-right: 25px;
            }

            cpu {
                margin-right: 25px;
            }

            memory {
                margin-right: 10px;
            }

            workspaces {
                margin-left: 35px;
            }

            network {
                margin-right: 25px;
            }

            title {
                margin-right: 25px;
            }

            date {
                color: #C5AAEC;
            }

            persistant_workspaces {
                letter-spacing: 10px;
                margin-left: 35px;
            }
          '';
        };
        ".config/waystatus/config.toml" = {
          text =
            let
              inherit (std) conversions;
            in
            ''
              unkown = "N/A"
              background = ${conversions.hexToRGBString "," "140F21"};
              layer = "bottom"
              topbar = true
              height = 40

              [[modules.left]]
              command.Workspaces = { active = " ", inactive = " " }

              [[modules.center]]
              command.Custom = { command = "date +%H:%M", name = "date", event = { TimePassed = 60000 }, formatting = " %s" }

              [[modules.right]]
              command.Custom = { command = "iwgetid -r", name = "network", event = { TimePassed = 10000 }, formatting = "  %s" }

              [[modules.right]]
              command.Cpu = { interval = 5000, formatting = "󰍛 %s%" }

              [[modules.right]]
              command.Memory = { memory_opts = "PercUsed", interval = 5000, formatting = "󰍛 %s%" }

              [[modules.right]]
              command.Audio = { formatting = "%c %s%", icons = ["", "", "󰕾", ""] }

              [[modules.right]]
              command.Backlight = { formatting = "%c %s%", icons = ["", "", "", "", "", "", "", "", ""] }

              [[modules.right]]
              command.Battery = { interval = 5000, formatting = "%c %s%", icons = ["󰁺" ,"󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"] }
            '';
        };
      };
    };
  };
}
