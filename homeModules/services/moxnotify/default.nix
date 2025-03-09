{ inputs, config, ... }:
{
  imports = [
    inputs.moxnotify.homeManagerModules.default
    inputs.moxnotify.homeManagerModules.stylix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      moxnotify = inputs.moxnotify.packages.${prev.system}.default;
    })
  ];

  services.moxnotify = {
    enable = true;
    settings = {
      max_icon_size = 60;
      default_timeout = 5;
      keymaps = {
        d.action = "dismiss_notification";
      };
      styles = {
        default = {
          buttons = {
            dismiss = {
              default = {
                background_color = config.lib.stylix.colors.withHashtag.base08;
                border_color = config.lib.stylix.colors.withHashtag.base08;
              };
              hover = {
                background_color = config.lib.stylix.colors.withHashtag.base07;
                border_color = config.lib.stylix.colors.withHashtag.base07;
              };
            };
            action = {
              default = {
                background_color = config.lib.stylix.colors.withHashtag.base08;
                border_color = config.lib.stylix.colors.withHashtag.base08;
              };
              hover = {
                background_color = config.lib.stylix.colors.withHashtag.base08;
                border_color = config.lib.stylix.colors.withHashtag.base08;
              };
            };
          };

          border.radius = {
            top_left = 5;
            top_right = 5;
            bottom_left = 5;
            bottom_right = 5;
          };
        };
      };

      notification = [
        {
          app = "discord";
          styles = {
            default.icon.border.radius = {
              top_left = 50;
              top_right = 50;
              bottom_left = 50;
              bottom_right = 50;
            };
          };
        }
        {
          app = "vesktop";
          styles = {
            default.icon.border.radius = {
              top_left = 50;
              top_right = 50;
              bottom_left = 50;
              bottom_right = 50;
            };
          };
        }
      ];

    };
  };
}
