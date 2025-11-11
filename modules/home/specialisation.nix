{
  lib,
  profile,
  config,
  ...
}:
let
  cfg = config.specialisations;
  inherit (lib) types;
in
{
  options.specialisations = {
    enable = lib.mkOption {
      type = types.bool;
      default = profile == "desktop";
    };
  };

  config.specialisation = lib.mkIf cfg.enable {
    "niri".configuration = {
      programs.niri.enable = true;
    };
    "hyprland".configuration = {
      programs.hyprland.enable = true;
    };
    "sway".configuration = {
      programs.sway.enable = true;
    };
    "gnome".configuration = {
      programs.gnome.enable = true;
    };
    "cosmic".configuration = { };
    "plasma".configuration = { };
  };
}
