{
  config,
  lib,
  profile,
  platform,
  ...
}:
let
  cfg = config.environment.notify;
in
{
  options.environment.notify = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = profile == "desktop";
    };
  };

  config = {
    home.persist.directories = [ ".local/share/moxnotify" ];
    nixpkgs.config.nixGLWrap = lib.mkIf (platform == "non-nixos") [ "moxnotify" ];
    services.moxnotify = {
      inherit (cfg) enable;
      settings = {
        general = {
          margin.top = 50;
          history.size = 10000;
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

    nix.settings = {
      substituters = [ "https://moxnotify.cachix.org" ];
      trusted-substituters = [ "https://moxnotify.cachix.org" ];
      trusted-public-keys = [ "moxnotify.cachix.org-1:YVtjC6ZS1as13P1zHHVi/p3bx93tGsP2mUjzEn3T4X4=" ];
    };
  };
}
