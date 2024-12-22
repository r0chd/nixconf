{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.environment;
in
{
  config = lib.mkIf (cfg.session == "Wayland") {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.enable = true;
  };
}
