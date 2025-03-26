{
  inputs,
  config,
  lib,
  system_type,
  ...
}:
let
  cfg = config.environment.notify;
in
{
  imports = [
    inputs.moxnotify.homeManagerModules.default
    inputs.moxnotify.homeManagerModules.stylix
  ];

  options.environment.notify = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = system_type == "desktop";
    };
  };

  config.services.moxnotify = {
    enable = cfg.enable;
    settings = {
      keymaps = {
        ge.action = "last_notification";
        d.action = "dismiss_notification";
        xd.action = "dismiss_notification";
      };

      next = {
        font = {
          color = "#FFFFFF";
        };
        border = {
          size = 1;
          radius = 0;
        };
        margin = 5;
        padding = 5;
      };
      prev = {
        font = {
          color = "#FFFFFF";
        };
        border = {
          size = 1;
          radius = 0;
        };
        margin = 5;
        padding = 5;
      };

      styles = {
        default = {
          progress.border = {
            size = 2;
            radius = 0;
          };

          buttons = {
            dismiss = {
              default = {
                padding = 0;
                margin = 0;
                background = "#FFFFFF";
                width = 20;
                height = 20;
                border = {
                  size = 0;
                  radius = 50;
                  color = "#000000";
                };
                font = {
                  size = 10;
                  color = "#000000";
                };
              };
              hover = {
                padding = 0;
                margin = 0;
                width = 20;
                height = 20;
                background = "#FFFFFF";
                font = {
                  size = 10;
                  color = "#FFFFFF";
                };
                border = {
                  size = 0;
                  radius = 0;
                  color = "#FFFFFF";
                };
              };
            };

            action = {
              default = {
                padding = 0;
                margin = 0;
                width = "auto";
                height = "auto";
                font.size = 10;
                border = {
                  size = 2;
                  radius = 0;
                };
              };
              hover = {
                padding = 0;
                margin = 0;
                width = "auto";
                height = "auto";
                font.size = 10;
                border = {
                  size = 2;
                  radius = 0;
                  color = "#FFFFFF";
                };
              };
            };
          };

          icon.border = {
            size = 0;
            radius = 0;
          };

          border = {
            size = 2;
            radius = 0;
          };
        };
      };
    };
  };
}
