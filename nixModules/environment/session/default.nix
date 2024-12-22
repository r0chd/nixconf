{ lib, ... }:
{
  imports = [
    ./wayland
    ./x11
    ./gaming
  ];

  config.programs.xwayland.enable = true;

  options.environment.session = lib.mkOption {
    type = lib.types.enum [
      "X11"
      "Wayland"
      "Gaming"
      "None"
    ];
    default = "None";
  };
}
