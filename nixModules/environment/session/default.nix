{ lib, ... }:
{
  imports = [
    ./wayland
    ./x11
  ];

  config.services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
    };
    touchpad = {
      accelProfile = "flat";
    };
  };

  options.environment.session = lib.mkOption {
    type = lib.types.enum [
      "X11"
      "Wayland"
      "None"
    ];
    default = "None";
  };
}
