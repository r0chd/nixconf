{ lib, ... }:
{
  imports = [
    ./wayland
    ./x11
  ];

  config.programs.xwayland.enable = true;

  options.environment.session = lib.mkOption {
    type = lib.types.enum [
      "X11"
      "Wayland"
      "None"
    ];
    default = "None";
  };
}
