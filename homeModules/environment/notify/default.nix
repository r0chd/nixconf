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
        margin.top = 50;

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
        ];

        default_sound_file = "/run/current-system/sw/share/sounds/freedesktop/stereo/message.oga";
      };
    };
  };
}
