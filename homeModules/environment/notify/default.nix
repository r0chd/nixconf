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

  config = {
    home.persist.directories = [ ".local/share/moxnotify" ];
    services.moxnotify = {
      inherit (cfg) enable;
      settings = {

        general = {
          margin.top = 50;
          history.size = 1000;
          #anchor = "top-right";
          default_sound_file = "/run/current-system/sw/share/sounds/freedesktop/stereo/message.oga";
          theme = "Cosmic";
        };

        styles = [ ];

        keymaps = [
          {
            mode = "n";
            keys = "d";
            action = "dismiss_notification";
          }
          {
            mode = "n";
            keys = "ge";
            action = "last_notification";
          }
          {
            mode = "n";
            keys = "<C-g>";
            action = "last_notification";
          }
          {
            mode = "n";
            keys = "gw";
            action = "hint_mode";
          }
          {
            mode = "n";
            keys = "f";
            action = "noop";
          }
        ];
      };
    };
  };
}
