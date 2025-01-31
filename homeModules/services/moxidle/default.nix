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

  services.moxidle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        unlock_cmd = "${pkgs.libnotify}/bin/notify-send 'unlock!'";
        before_sleep_cmd = "${pkgs.libnotify}/bin/notify-send 'Zzz'";
        after_sleep_cmd = "${pkgs.libnotify}/bin/notify-send 'Awake!'";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_audio_inhibit = false;
      };
      timeouts = [
        {
          timeout = 300;
          on_timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          on_resume = "${pkgs.libnotify}/bin/notify-send 'Welcome back!'";
        }
        {
          timeout = 1800;
          on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
          on_resume = "${pkgs.libnotify}/bin/notify-send 'Welcome back!'";
        }
      ];
    };
  };
}
