{
  conf,
  pkgs,
}: let
  inherit (conf) username;
in {
  security.pam.services.hyprlock = {};
  home-manager.users."${username}" = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          no_fade_in = false;
          disable_loading_bar = true;
          grace = 0;
        };
        background = [
          {
            monitor = "";
            color = "rgba(25, 20, 20, 1.0)";
            blur_passes = 1;
            blur_size = 0;
            brightness = 0.2;
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "250, 60";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.5)";
            font_color = "rgb(200, 200, 200)";
            fade_on_empty = false;
            placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
            hide_input = false;
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 120;
            position = "0, 80";
            valign = "center";
            halign = "center";
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = true;
          lock_cmd = "pidof hyprlock || hyprlock";
        };
        listener = let
          lockScript = pkgs.writeShellScript "lock-script" ''
            action=$1
            pw-cli i all | rg running
            if [ $? == 1 ]; then
              if [ "$action" == "lock" ]; then
                hyprlock
              elif [ "$action" == "suspend" ]; then
                systemctl suspend
              fi
            fi
          '';
        in [
          {
            timeout = 300;
            on-timeout = "${lockScript.outPath} lock";
          }
          {
            timeout = 1800;
            on-timeout = "${lockScript.outPath} suspend";
          }
        ];
      };
    };
  };
}
