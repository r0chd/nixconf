{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.moxidle.homeManagerModules.default
  ];

  nixpkgs.overlays = [
    (final: prev: {
      moxidle = inputs.moxidle.packages.${prev.system}.default;
    })
  ];

  services.moxidle =
    let
      dbus_cmd = "${pkgs.dbus}/bin/dbus-send --session --dest=org.freedesktop.ScreenSaver --print-reply /org/freedesktop/ScreenSaver org.freedesktop.ScreenSaver.GetActiveTime";
      message = "${pkgs.libnotify}/bin/notify-send \"You've been inactive for $(${dbus_cmd} | ${pkgs.gawk}/bin/awk '/uint32/ {print $2}' | ${pkgs.gawk}/bin/awk '{h=int($1/3600); m=int(($1%3600)/60); s=$1%60; printf \"%02d:%02d:%02d\", h, m, s}')\"";
    in
    {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock && ${pkgs.systemd}/bin/loginctl unlock-session";
          unlock_cmd = message;
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
          ignore_audio_inhibit = false;
        };
        timeouts = [
          {
            conditions = [
              "on_battery"
              { battery_level = "critical"; }
              { battery_state = "discharging"; }
            ];
            timeout = 300;
            on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
            on_resume = message;
          }
          {
            conditions = [ "on_ac" ];
            timeout = 300;
            on_timeout = "${pkgs.systemd}/bin/loginctl lock-session";
            on_resume = message;
          }
          {
            conditions = [ "on_ac" ];
            timeout = 900;
            on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
            on_resume = "";
          }
        ];
      };
    };
}
